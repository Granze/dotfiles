# dotfiles

Personal configurations for Aurora Linux (immutable / Fedora-based), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
.dotfiles/
├── install.sh          # Bootstrap script (Homebrew, Stow, Kitty, packages)
├── packages.txt        # Brew packages to install
├── kitty/              # Stow module → ~/.config/kitty/
│   └── .config/kitty/
│       ├── kitty.conf
│       ├── current-theme.conf
│       └── quick-access-terminal.conf
├── starship/           # Stow module → ~/.config/starship.toml
│   └── .config/
│       └── starship.toml
└── zsh/                # Stow module → ~/.zshrc
    └── .zshrc
```

### What gets installed

- **Homebrew** — package manager (linuxbrew)
- **Kitty** — GPU-accelerated terminal (official installer)
- **Zsh** — shell + autosuggestions, syntax highlighting, completions
- **Starship** — minimal and fast prompt (config included)
- **FiraCode Nerd Font** — patched font with icons and ligatures
- **CLI tools** (from `packages.txt`): `fzf`, `eza`, `bat`, `zoxide`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`

### Prerequisites

System packages required (should be pre-installed on Aurora):

- `git`, `curl`

> `fzf` and `starship` are included in Aurora by default. If missing on other distros, they will be installed via Homebrew by `install.sh`.

## Installation

```bash
git clone <repo-url> ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

The script will:

1. Install Homebrew (if missing)
2. Install GNU Stow and Zsh via brew
3. Install Kitty via the official installer
4. Install FiraCode Nerd Font (downloaded from GitHub)
5. Install packages listed in `packages.txt`
6. Create symlinks with `stow --restow` for each module
7. Set Zsh as the default shell
8. Ensure brew and kitty are in PATH

When done, restart your terminal or run:

```bash
source ~/.zshrc
```

## Adding a new module

Create a directory that mirrors the home directory structure. For example, for `~/.config/starship.toml`:

```bash
mkdir -p starship/.config
cp ~/.config/starship.toml starship/.config/
cd ~/.dotfiles && stow starship
```

## Adding packages

Add the package name to `packages.txt` (one per line) and run:

```bash
brew install <package>
```

or re-run `./install.sh`.
