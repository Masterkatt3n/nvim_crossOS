#!/usr/bin/env bash
set -euo pipefail
trap 'echo "[✗] Script failed at line $LINENO"' ERR

for cmd in curl git wget sudo; do
  command -v "$cmd" >/dev/null || {
    echo "[✗] Required command missing: $cmd"
    exit 1
  }
done

#######################################
# User-configurable variables
#######################################

LLVM_VERSION=20 # Optional: Defaults to the latest stable version, 18 works too without edits

#######################################
# Setup logging
#######################################
mkdir -p "$HOME/neovimBackup/config"
LOG_FILE="$HOME/neovimBackup/config/build-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee "${LOG_FILE}") 2>&1
echo "[i] Neovim clean rebuild starting…"
SCRIPT_START_TIME=$(date +%s)

#######################################
# * Setup environment checks *
#######################################

is_wsl=false

if grep -qi microsoft /proc/version; then
  is_wsl=true
fi

# Env banner
echo "[*] Environment:"
echo "    OS      : $(uname -s)"
echo "    Kernel  : $(uname -r)"
echo "    WSL     : $is_wsl"

#######################################
# * Installing Nala to speed things up *
#######################################

if ! command -v nala >/dev/null 2>&1; then
  echo "[*] Ensuring 'universe' repository is enabled..."

  sudo apt-get update -y
  sudo apt-get install -y software-properties-common
  sudo add-apt-repository -y universe

  echo "[*] Installing Nala..."

  sudo apt-get install -y nala

  echo "[✓] Nala installed"
else
  echo "[✓] Nala already installed"
fi

#######################################
# * Reboot advisory *
#######################################

if [[ -f /var/run/reboot-required ]]; then
  echo
  echo "[!] System reboot recommended before continuing"
  echo "    Reason:"
  echo "[!] Reboot required — stopping script here."
  echo "[!] Re-run the script after reboot to continue setup."
  echo

  exit 0
fi

#######################################
# * Upgrading OS tools *
#######################################

echo "[i] Upgrading system..."
sudo nala upgrade -y #!NOTE System wide upgrade

echo "[✓] System upgraded."

#######################################
# * Installing toolchains *
#######################################

echo "[i] Installing toolchains;"

#######################################
# * LLVM / clang
#######################################
CLANG_BIN="clang-$LLVM_VERSION"

if ! command -v "$CLANG_BIN" >/dev/null 2>&1; then
  echo "[*] Installing LLVM/clang (v$LLVM_VERSION)..."
  curl -fsSL https://apt.llvm.org/llvm.sh | sudo bash -s -- "$LLVM_VERSION"

else
  echo "[✓] clang already installed: $($CLANG_BIN --version | head -n1)"
fi

#######################################
# * Node.js (LTS)
#######################################
if ! command -v node >/dev/null 2>&1; then
  echo "[*] Installing Node.js (LTS)..."
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt install -y nodejs
else
  echo "[✓] Node.js already installed: $(node --version)"
fi

#######################################
# * Rust (nightly default + stable fallback)
#######################################
if ! command -v cargo >/dev/null 2>&1; then
  echo "[*] Installing Rust (nightly default, minimal profile)..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs |
    sh -s -- -y --default-toolchain nightly --profile minimal
else
  echo "[✓] rustup already installed."
fi

# Load cargo environment
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
else
  echo "[✗] Rust environment not found after install"
  exit 1
fi

# Ensure both toolchains exist
rustup toolchain install stable >/dev/null 2>&1 || true
rustup toolchain install nightly >/dev/null 2>&1 || true
rustup default nightly # Some plugins depends on nightly for now

# Useful components
rustup component add rustfmt clippy

echo "[✓] Rust toolchains ready:"
echo "    rustc: $(rustc --version)"
echo "    cargo: $(cargo --version)"

#######################################
# * Install native build dependencies *
#######################################
echo "[i] Installing native build dependencies..."

sudo apt install -y \
  build-essential \
  fzf \
  git \
  sed \
  dkms \
  wget \
  make \
  perl \
  gawk \
  curl \
  unzip \
  cmake \
  libtool \
  gettext \
  libssl-dev \
  ninja-build \
  python3-pip \
  python3-dev \
  pkg-config \
  libtool-bin \
  python3-venv \
  apt-transport-https \
  software-properties-common

echo "[✓] Native build deps installed."

#######################################
# * Select LLVM toolchain
#######################################
echo "[i] Installing Cargo CLI tools..." # Enhancing the compiler, ensuring the lateast components fetch get used

if command -v "$CLANG_BIN" >/dev/null 2>&1; then
  export CC="clang-$LLVM_VERSION"
  export CXX="clang++-$LLVM_VERSION"
  export LD="ld.lld-$LLVM_VERSION"
elif command -v clang-18 >/dev/null 2>&1; then
  export CC=clang-18
  export CXX=clang++-18
  export LD=ld.lld-18
else
  export CC=clang
  export CXX=clang++
  export LD=ld
fi

echo "[*] Using compiler:"
echo "    CC=$CC"
echo "    CXX=$CXX"
echo "    LD=$LD"

# Defaults to NeoVim tools
# ..and some nice optional suggestions, uncomment
cargo_bins=(
  # "sd:sd"
  # "eza:eza"
  # "bat:bat"
  "fd-find:fd"
  "ripgrep:rg"
  # "b3sum:b3sum"
  "stylua:stylua"
  # "zoxide:zoxide"
  "ast-grep:ast-grep"
  #!NOTE not 'needed' but highly recommended to easily update tools
  # "cargo-info:cargo-info"
  # "cargo-update:cargo-update"
  "tree-sitter-cli:tree-sitter"

)

for entry in "${cargo_bins[@]}"; do
  crate="${entry%%:*}"
  bin="${entry##*:}"

  if command -v "$bin" >/dev/null 2>&1; then
    echo "[✓] $crate already installed ($bin)"
  else
    echo "[*] Installing $crate"
    cargo install "$crate"
  fi
done

echo "[✓] Cargo tools installation complete."

#######################################
# * Lazygit Installation
#######################################

install_lazygit() {
  if command -v lazygit >/dev/null 2>&1; then
    echo "[✓] lazygit already installed: $(lazygit --version)"
    return
  fi

  echo "[i] Installing lazygit (official binary)..."

  mkdir -p ~/.local/bin
  TMP_DIR=$(mktemp -d)
  pushd "$TMP_DIR" >/dev/null

  VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
    grep tag_name | cut -d '"' -f 4)

  curl -Lo lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${VERSION#v}_Linux_x86_64.tar.gz"

  tar xf lazygit.tar.gz lazygit
  install lazygit ~/.local/bin

  export PATH="$HOME/.local/bin:$PATH"

  echo "[✓] lazygit installed: $(lazygit --version)"

  popd >/dev/null
  rm -rf "$TMP_DIR"

}

install_lazygit

#######################################
# * Ensure Cargo bin path is sourced *
#######################################

CARGO_ENV="$HOME/.cargo/env"

if ! grep -q '.cargo/env' "$HOME/.bashrc"; then
  echo "[*] Adding Cargo env sourcing to ~/.bashrc"
  {
    echo
    echo "# Rust / Cargo"
    echo "source \"$CARGO_ENV\""
  } >>"$HOME/.bashrc"
fi

#######################################
# * Shell integrations (zoxide) *
#######################################

if command -v zoxide >/dev/null 2>&1; then
  if ! grep -q 'zoxide init bash' "$HOME/.bashrc"; then
    echo "[*] Enabling zoxide shell integration"
    {
      echo
      echo "# zoxide (smart cd)"
      echo 'if command -v zoxide >/dev/null 2>&1; then'
      # shellcheck disable=SC2016
      echo '  eval "$(zoxide init bash)"'
      echo 'fi'
    } >>"$HOME/.bashrc"
  else
    echo "[✓] zoxide shell integration already present"
  fi
fi

#######################################
# * Ensure ~/.local/bin is in PATH (WSL-safe)
#######################################

if ! grep -q '.local/bin' "$HOME/.bashrc"; then
  echo "[*] Ensuring ~/.local/bin is in PATH"
  {
    echo
    echo '# Ensure ~/.local/bin is always in PATH (WSL-safe)'
    # shellcheck disable=SC2016
    echo 'case ":$PATH:" in'
    # shellcheck disable=SC2016
    echo '*":$HOME/.local/bin:"*) ;;'
    # shellcheck disable=SC2016
    echo '*) PATH="$HOME/.local/bin:$PATH" ;;'
    echo 'esac'
  } >>"$HOME/.bashrc"
fi

# Also source it for current run
source "$CARGO_ENV"

#######################################
# - Sanity checks
#######################################
echo "[*] Toolchain summary:"
if command -v "$CLANG_BIN" >/dev/null 2>&1; then
  "$CLANG_BIN" --version | head -n1
fi
command -v node >/dev/null && node --version
command -v cargo >/dev/null && cargo --version
command -v rustc >/dev/null && rustc --version

echo "[*] Cargo installatins tests:"
which tree-sitter
which fd
which rg

echo "[✓] Environment refresh + toolchains complete."
echo "[i] Neovim paths cleansing starting…"

#######################################
# * Backup current config
#######################################
BACKUP="$HOME/nvimBackup-$(date +%Y%m%d-%H%M%S).tar.gz"
echo "[*] Backing up ~/.config/nvim → $BACKUP"

if [[ -d "$HOME/.config/nvim" ]]; then
  tar -czvf "$BACKUP" -C "$HOME/.config" nvim
else
  echo "[!] ~/.config/nvim not found, skipping backup"
fi

#######################################
# - Remove old installs
#######################################
echo "[*] Removing old Neovim installs" # Not system installed Vim

installpathsToPurge=(
  "/usr/local/bin/nvim"
  "/usr/bin/nvim"
  "$HOME/github/neovim"
)

for path in "${installpathsToPurge[@]}"; do
  if [[ -e "$path" && "$path" == /* ]]; then
    sudo rm -rf "$path"
    echo "Deleted: $path"
  else
    echo "Not present or unsafe path: $path"
  fi
done

#######################################
# - Purge Neovim user state (XDG)
#######################################
echo "[*] Purging Neovim user state..."

pathsToPurge=(
  "$HOME/.cache/nvim"
  "$HOME/.local/state/nvim"
  "$HOME/.local/share/nvim"
  "$HOME/.config/nvim"
)

for path in "${pathsToPurge[@]}"; do
  if [[ -e "$path" ]]; then
    rm -rf "$path"
    echo "Deleted: $path"
  else
    echo "Not present: $path"
  fi
done

echo "[✓] Neovim clean rebuild complete"

#######################################
# * Clone Neovim config repo
#######################################
echo "[i] Starting Neovim build..."
echo "[*] Cloning Neovim config repository"

mkdir -p "$HOME/.config/nvim"
git clone https://github.com/Masterkatt3n/nvim_crossOS ~/.config/nvim

echo "[✓] Neovim config repo cloned."

#######################################
# - Clone Neovim repo
#######################################
echo "[*] Cloning Neovim build repository"

mkdir -p "$HOME/github"
cd "$HOME/github"

git clone https://github.com/neovim/neovim.git
cd neovim

# Optional: pin to known-good commit or tag
# git checkout cdc6f85
echo "[✓] Neovim build repo cloned."

#######################################
# * Build Neovim
#######################################
echo "[i] Building Neovim (RelWithDebInfo)"
# Builds the latest commit, change to 'Release' for stable version
# Running llvm-20 + Ninja backend for speed

make distclean

make -j"$(nproc)" \
  CMAKE_BUILD_TYPE=RelWithDebInfo \
  CMAKE_EXTRA_FLAGS="\
    -DCMAKE_C_COMPILER=$CC \
    -DCMAKE_CXX_COMPILER=$CXX \
    -DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=lld-$LLVM_VERSION \
    -DCMAKE_SHARED_LINKER_FLAGS=-fuse-ld=lld"

echo "[✓] Neovim build complete."

#######################################
# - Package & install (.deb)
#######################################
echo "[*] Packaging Neovim (.deb)"

cd build
cpack -G DEB

shopt -s nullglob

for _ in {1..10}; do
  deb_files=(nvim-linux-*.deb)
  ((${#deb_files[@]} == 1)) && break
  sleep 0.2
done

if ((${#deb_files[@]} != 1)); then
  echo "[✗] Expected exactly one .deb, found ${#deb_files[@]}"
  exit 1
fi

echo "[*] Installing ${deb_files[0]}"
sudo dpkg -i "${deb_files[0]}"

#######################################
# - Verify install
#######################################
echo
echo "[✓] Neovim installed successfully:"
nvim --version | head -n 5

######################################
# - Install fonts
######################################
FONT_DIR="$HOME/.local/share/fonts"
FONT_FILE="$FONT_DIR/JetBrainsMonoNerdFont-Regular.ttf"

echo "[i] Checking for fonts..."

if [[ -f "$FONT_FILE" ]]; then
  echo "[✓] Nerd fonts already installed."
else
  echo "[*] Fetching and installing fonts"
  mkdir -p "$FONT_DIR"
  cd "$FONT_DIR"

  curl -L -O \
    'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip'

  unzip -o JetBrainsMono.zip
  fc-cache -f -v

  echo "[✓] Nerd fonts installed."
fi

#######################################
# * Install PowerShell (pwsh) *
#######################################

install_powershell() {
  if command -v pwsh >/dev/null 2>&1; then
    echo "[✓] PowerShell already installed: $(pwsh --version)"
    return 0
  fi

  echo "[i] Installing PowerShell via Microsoft APT repo..."

  # Add Microsoft package repo (idempotent)
  if [[ ! -f /etc/apt/sources.list.d/microsoft-prod.list ]]; then
    echo "[*] Adding Microsoft package repository"
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
      -O /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb
    rm -f /tmp/packages-microsoft-prod.deb
  else
    echo "[✓] Microsoft package repository already present"
  fi

  # Install PowerShell
  sudo nala update
  sudo nala install -y powershell

  echo "[✓] PowerShell installed: $(pwsh --version)"
}

install_powershell

# Extra Optionals, fully enable(silence warningflags) neovim
# add deps for markdown-preview
echo "[i] Installing pynvim, pylatexenc and npm neovim..."

pip3 install --user --upgrade pynvim
pip3 install --user --upgrade pylatexenc
sudo npm install -g neovim

echo "[✓] done installing extra optionals."

# - Process summary
SCRIPT_END_TIME=$(date +%s)
ELAPSED=$((SCRIPT_END_TIME - SCRIPT_START_TIME))

printf "\n"
echo "===================================="
echo "[✓] Setup complete!"
printf "\n"
echo "  llvm:  $($CLANG_BIN --version)"
echo "  rust:  $(rustc --version)"
echo "  node:  $(node --version)"
echo "  nvim:  $(nvim --version | head -n1)"
printf "\n"
printf "⏱  Total execution time: %02dh:%02dm:%02ds\n" \
  $((ELAPSED / 3600)) \
  $(((ELAPSED % 3600) / 60)) \
  $((ELAPSED % 60))
echo "===================================="
echo "Don't forget to source profile:"
printf "\n"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-->"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_--> source $HOME/.bashrc"
