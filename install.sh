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
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
  # Create symlinks in PATH
  mkdir -p "$HOME/.local/bin"
  ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
  ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
  ok "Kitty"
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
  stow --restow "$module" 2>&1 | tee -a "$LOG" || {
    log "  WARN: stow $module failed — file conflict. Resolve manually."
  }
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
  if ! grep -q "$ZSH_PATH" /etc/shells; then
    log "WARN: $ZSH_PATH is not in /etc/shells."
    log "  On immutable systems /etc/shells is read-only."
    log "  Run manually: sudo sh -c 'echo $ZSH_PATH >> /etc/shells'"
  fi
  chsh -s "$ZSH_PATH"
  ok "Default shell → zsh ($ZSH_PATH)"
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
