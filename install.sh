#!/usr/bin/env bash
# ============================================================
# dotfiles bootstrap — Aurora Linux (immutable / Fedora-based)
# Usage: git clone <repo> ~/.dotfiles && cd ~/.dotfiles && ./install.sh
# ============================================================
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
LOG="$DOTFILES/install.log"

log()  { echo "[$(date +%H:%M:%S)] $*" | tee -a "$LOG"; }
ok()   { echo "  ✓ $*"; }
skip() { echo "  · $* (already present, skipping)"; }

log "=== dotfiles bootstrap start ==="

# ─── 1. Homebrew ────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for this session
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  ok "Homebrew installed"
else
  skip "Homebrew"
fi

# Ensure brew is in PATH
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null || true

# ─── 2. GNU Stow ────────────────────────────────────────────
if ! command -v stow &>/dev/null; then
  log "Installing stow..."
  brew install stow
  ok "stow"
else
  skip "stow"
fi

# ─── 3. Zsh ─────────────────────────────────────────────────
if ! command -v zsh &>/dev/null; then
  log "Installing zsh..."
  brew install zsh
  ok "zsh"
else
  skip "zsh"
fi

# ─── 4. Kitty (official installer) ──────────────────────────
if ! command -v kitty &>/dev/null && [ ! -d "$HOME/.local/kitty.app" ]; then
  log "Installing Kitty terminal..."
  if curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
    ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
    # Desktop integration
    mkdir -p "$HOME/.local/share/applications"
    cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" "$HOME/.local/share/applications/"
    cp "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$HOME/.local/share/applications/"
    KITTY_ICON="$(readlink -f "$HOME")/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png"
    KITTY_BIN="$(readlink -f "$HOME")/.local/kitty.app/bin/kitty"
    sed -i "s|Icon=kitty|Icon=$KITTY_ICON|g" "$HOME/.local/share/applications/kitty"*.desktop
    sed -i "s|Exec=kitty|Exec=$KITTY_BIN|g" "$HOME/.local/share/applications/kitty"*.desktop
    # Set kitty as default xdg terminal
    mkdir -p "$HOME/.config"
    echo 'kitty.desktop' > "$HOME/.config/xdg-terminals.list"
    if [ -x "$HOME/.local/kitty.app/bin/kitty" ]; then
      ok "Kitty"
    else
      log "  WARN: Kitty installer exited 0 but binary not found at ~/.local/kitty.app/bin/kitty"
      log "  Try manually: curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n"
    fi
  else
    log "  WARN: Kitty installer failed. Install manually."
    log "  Try: curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n"
  fi
else
  skip "Kitty"
fi

# ─── 5. FiraCode Nerd Font ──────────────────────────────────
FONT_DIR="$HOME/.local/share/fonts"
if ! fc-list | grep -qi "FiraCode Nerd Font"; then
  log "Installing FiraCode Nerd Font..."
  mkdir -p "$FONT_DIR"
  curl -fLo /tmp/FiraCode.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
  unzip -o /tmp/FiraCode.zip -d "$FONT_DIR"
  rm /tmp/FiraCode.zip
  fc-cache -f "$FONT_DIR"
  ok "FiraCode Nerd Font"
else
  skip "FiraCode Nerd Font"
fi

# ─── 6. Brew packages (from packages.txt) ───────────────────
PACKAGES_FILE="$DOTFILES/packages.txt"
if [ -f "$PACKAGES_FILE" ]; then
  log "Installing brew packages from packages.txt..."
  while IFS= read -r pkg || [ -n "$pkg" ]; do
    # Skip blank lines and comments
    [[ -z "$pkg" || "$pkg" == \#* ]] && continue
    if brew list "$pkg" &>/dev/null 2>&1; then
      skip "$pkg"
    else
      log "  brew install $pkg"
      brew install "$pkg" && ok "$pkg"
    fi
  done < "$PACKAGES_FILE"
else
  log "No packages.txt found, skipping."
fi

# ─── 7. Symlinks via Stow ───────────────────────────────────
log "Creating symlinks with stow..."
cd "$DOTFILES"

# Each top-level directory is a stow module
for module in */; do
  module="${module%/}"
  # Skip non-module directories
  [[ "$module" == "assets" || "$module" == ".git" ]] && continue
  [ ! -d "$module" ] && continue

  log "  stow $module"
  if ! stow --restow "$module" 2>/dev/null; then
    log "  Conflict in $module — adopting existing files and restoring from git..."
    stow --adopt --restow "$module" 2>&1 | tee -a "$LOG"
    # Restore our dotfiles versions (overwrite whatever was adopted)
    git -C "$DOTFILES" checkout -- "$module/" 2>/dev/null || true
    stow --restow "$module" 2>&1 | tee -a "$LOG" || \
      log "  WARN: stow $module still failed — resolve manually."
  fi
done

ok "Symlinks created"

# ─── 8. Set zsh as default shell ────────────────────────────
# Prefer system zsh (/usr/bin/zsh) since it is already listed in
# /etc/shells and does not require modifying the immutable filesystem.
if command -v /usr/bin/zsh &>/dev/null; then
  ZSH_PATH="/usr/bin/zsh"
else
  ZSH_PATH="$(command -v zsh)"
fi

if [ "$SHELL" != "$ZSH_PATH" ]; then
  log "Setting zsh as default shell..."
  if command -v chsh &>/dev/null; then
    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
      log "  WARN: $ZSH_PATH not in /etc/shells (immutable fs)."
      log "  Run manually: sudo sh -c 'echo $ZSH_PATH >> /etc/shells'"
    fi
    chsh -s "$ZSH_PATH" && ok "Default shell → zsh ($ZSH_PATH)" || \
      log "  WARN: chsh failed — run: sudo usermod --shell $ZSH_PATH $USER"
  elif command -v usermod &>/dev/null; then
    log "  chsh not found, using usermod (requires sudo)..."
    sudo usermod --shell "$ZSH_PATH" "$USER" && ok "Default shell → zsh ($ZSH_PATH)" || \
      log "  WARN: usermod failed — set shell manually: sudo usermod --shell $ZSH_PATH $USER"
  else
    log "  WARN: Neither chsh nor usermod found. Set shell manually:"
    log "  sudo usermod --shell $ZSH_PATH $USER"
  fi
else
  skip "Shell already set to zsh"
fi

# ─── 9. Ensure brew & kitty are in PATH ─────────────────────
# The stow-managed .zshrc already includes brew and kitty PATH entries.
# Only append them if .zshrc is a regular file (not a stow symlink),
# e.g. after a partial install.
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ] && [ ! -L "$ZSHRC" ]; then
  if ! grep -q "linuxbrew" "$ZSHRC"; then
    log "Adding brew to PATH in .zshrc..."
    echo '' >> "$ZSHRC"
    echo '# Homebrew (added by install.sh)' >> "$ZSHRC"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$ZSHRC"
  fi
  if ! grep -q "kitty.app" "$ZSHRC"; then
    log "Adding kitty to PATH in .zshrc..."
    echo '' >> "$ZSHRC"
    echo '# Kitty (added by install.sh)' >> "$ZSHRC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZSHRC"
  fi
fi

log "=== Bootstrap complete! ==="
echo ""
echo "  Restart your terminal or run: source ~/.zshrc"
echo "  Full log: $LOG"
