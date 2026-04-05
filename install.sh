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
  # Aggiungi brew al PATH per questa sessione
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  ok "Homebrew installato"
else
  skip "Homebrew"
fi

# Assicurati che brew sia nel PATH
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

# ─── 4. Kitty (installer ufficiale) ─────────────────────────
if ! command -v kitty &>/dev/null && [ ! -d "$HOME/.local/kitty.app" ]; then
  log "Installing Kitty terminal..."
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
  # Crea symlink nel PATH
  mkdir -p "$HOME/.local/bin"
  ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
  ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
  ok "Kitty"
else
  skip "Kitty"
fi

# ─── 5. Tool da brew (da packages.txt) ──────────────────────
PACKAGES_FILE="$DOTFILES/packages.txt"
if [ -f "$PACKAGES_FILE" ]; then
  log "Installing brew packages from packages.txt..."
  while IFS= read -r pkg || [ -n "$pkg" ]; do
    # Salta righe vuote e commenti
    [[ -z "$pkg" || "$pkg" == \#* ]] && continue
    if brew list "$pkg" &>/dev/null 2>&1; then
      skip "$pkg"
    else
      log "  brew install $pkg"
      brew install "$pkg" && ok "$pkg"
    fi
  done < "$PACKAGES_FILE"
else
  log "Nessun packages.txt trovato, skip."
fi

# ─── 6. Symlink con Stow ────────────────────────────────────
log "Creating symlinks with stow..."
cd "$DOTFILES"

# Lista moduli: ogni cartella in .dotfiles è un modulo stow
for module in */; do
  module="${module%/}"
  # Salta cartelle non-modulo
  [[ "$module" == "assets" || "$module" == ".git" ]] && continue
  [ ! -d "$module" ] && continue

  log "  stow $module"
  stow --restow "$module" 2>&1 | tee -a "$LOG" || {
    log "  WARN: stow $module fallito — conflitto di file. Risolvi manualmente."
  }
done

ok "Symlink creati"

# ─── 7. Zsh come shell di default ───────────────────────────
ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
  log "Impostando zsh come shell di default..."
  # Aggiungi zsh di brew a /etc/shells se non presente
  if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi
  chsh -s "$ZSH_PATH"
  ok "Shell di default → zsh ($ZSH_PATH)"
else
  skip "Shell già impostata su zsh"
fi

# ─── 8. Aggiungi brew + kitty al .zshrc se non già presente ─
ZSHRC="$HOME/.zshrc"
if [ -f "$ZSHRC" ]; then
  if ! grep -q "linuxbrew" "$ZSHRC"; then
    log "Aggiungendo brew al PATH in .zshrc..."
    echo '' >> "$ZSHRC"
    echo '# Homebrew (aggiunto da install.sh)' >> "$ZSHRC"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$ZSHRC"
  fi
  if ! grep -q "kitty.app" "$ZSHRC"; then
    log "Aggiungendo kitty al PATH in .zshrc..."
    echo '' >> "$ZSHRC"
    echo '# Kitty (aggiunto da install.sh)' >> "$ZSHRC"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZSHRC"
  fi
fi

log "=== Bootstrap completato! ==="
echo ""
echo "  Riavvia il terminale oppure esegui: source ~/.zshrc"
echo "  Log completo: $LOG"
