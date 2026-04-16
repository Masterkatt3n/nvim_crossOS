# nvim_crossOS

A **cross-platform Neovim configuration** designed to run unmodified on
**Windows, WSL, and Linux**, with a strong focus on:

- predictable behavior across OSes
- explicit LSP configuration
- minimal magic
- readable Lua over clever Lua

This config is actively evolving and intentionally opinionated.

---

## ✨ Goals

- **Single config, multiple platforms**
  No OS-specific forks or manual edits.

- **Explicit over implicit**
  If something is enabled, it’s done deliberately.

- **LSP-first editing**
  Language servers, diagnostics, and tooling are configured carefully
  (and not blindly copy-pasted).

- **Noise-free diagnostics**
  `lua_ls` is tuned to be _useful_, not naggy.

- **Composable setup**
  Pieces are meant to be reused, replaced, or removed without collapse.

- **PowerShell (`PSES`)**
  Content around the `PowerShell` LSP was somewhat scarce or outdated when I started.
  I do most of my work in PowerShell, so these settings may be useful to others.

---

## 🖥 Supported Platforms

- Windows 11 (native Neovim)
- Ubuntu 24.04 LTS (WSL and native)
- Ubuntu 22.04 LTS (WSL and native)

> The same config is expected to work on all of the above without modification.
> Ubuntu 20.04 LTS also worked with minor adjustments, but it is not a target platform for this script and Nala does not support it.

> The script is intentionally opinionated and follows current Ubuntu LTS releases rather than maintaining compatibility with older releases indefinitely. The bootstrap script has been tested on both WSL and native Ubuntu.
> Other Debian-based systems will likely work but are not guaranteed.

---

## 📦 Plugin Management

This configuration uses **[lazy.nvim](https://github.com/folke/lazy.nvim)**.

Plugins are:

- grouped by responsibility
- loaded lazily where possible
- configured in isolated modules

---

## 🧠 LSP Philosophy

- Capabilities are **constructed explicitly**
- Optional plugin APIs (e.g. `blink.cmp`) are guarded safely
- Dynamic Lua patterns are acknowledged where static analysis falls short
- Diagnostics are suppressed **only when justified**

If something looks verbose, it’s usually intentional.

---

## 🗂 Directory Layout (high level)

```text
.
├── lua/
│   ├── config/            # Core editor behavior (no plugins)
│   │   ├── ftypes/        # Filetype detection / overrides
│   │   ├── lsp/           # LSP logic (capabilities, helpers, semantics)
│   │   ├── tracker/       # Small internal helpers / experiments
│   │   ├── autocmds.lua   # Autocommands
│   │   ├── diagnostics.lua# Diagnostic config
│   │   ├── keymaps.lua    # Keybindings
│   │   ├── lazy.lua       # Plugin bootstrap (lazy.nvim setup)
│   │   └── options.lua    # vim.opt + globals
│   │
│   ├── plugins/           # Plugin specs (1 file = 1 plugin)
│   │   ├── blink.lua
│   │   ├── blinkPairs.lua
│   │   ├── colorscheme.lua
│   │   ├── conform.lua
│   │   ├── lint.lua
│   │   ├── lsp.lua
│   │   ├── lua.lua
│   │   ├── lualine.lua
│   │   ├── mason.lua
│   │   ├── matchUp.lua
│   │   ├── mini-pairsOff.lua
│   │   └── treesitter.lua
│   │
│   └── types/             # Type hints / annotations (dev UX)
│       └── lazy.lua
│
├── scripts/               # External tooling / reproducible setup
│   └── bootstrap-buildnvim.sh
│
├── init.lua               # Entry point
├── stylua.toml            # Formatting rules
├── pyproject.toml         # Python tooling (optional integration)
├── README.md
└── LICENSE
```

This may evolve, but the guiding rule is:

One file = one responsibility.

---

## ⚠️ Status

This is not a “finished” config, but everything here does work.

The setup is intentionally kept basic and lean, without every plugin I personally use,
but it should still be easy to extend or adapt without much friction.

This is a spare-time project, so active support should not be expected.

Expect:

- refactors
- occasional breaking changes (or long periods without updates)
- experiments
- rewrites when something becomes clearer

That’s by design.

---

## Installation (try-it-as-is)

This config assumes Neovim ≥ 0.10 and uses Lazy.nvim.

### Unix / WSL

```sh
git clone https://github.com/Masterkatt3n/nvim_crossOS ~/.config/nvim
```

### Windows (PowerShell)

```powershell
git clone https://github.com/Masterkatt3n/nvim_crossOS $env:USERPROFILE\.config\nvim
```

- On first start, Lazy.nvim will install plugins automatically.

---

## 🔧 Optional: Full Clean WSL Build (LLVM + Ninja + Nightly Rust)

For users who want a fully reproducible Neovim build from source
(using LLVM 20, Ninja, Rust nightly, and a clean XDG state), a bootstrap script is provided:

```bash
scripts/bootstrap-buildnvim.sh
```

### What it does

The script performs a deterministic rebuild of Neovim and its supporting toolchain.

It will:

- Ensure the `universe` repository is enabled

- Install `nala` (APT frontend)

- Perform a full system upgrade

- Install toolchains:
  - LLVM/clang (v20)
  - Rust (nightly default + stable fallback)
  - Node.js (LTS)

- Install native build dependencies (cmake, ninja, etc.)

- Install Cargo CLI tools:
  - `ripgrep`
  - `fd`
  - `ast-grep`
  - `stylua`
  - `tree-sitter-cli`

- Install `lazygit`

- Ensure `~/.cargo` and `~/.local/bin` are properly added to `PATH`

- Backs up existing `~/.config/nvim`

- Purges Neovim user state (`cache`, `data`, `config`)

- Clone this configuration repository
- Clone and build Neovim from source:
  - `RelWithDebInfo`
  - Ninja backend
  - LLVM toolchain
  - LLD linker

- Package and install Neovim as `.deb`

- Installs JetBrainsMono Nerd Font

- Installs PowerShell (`pwsh`)

- Installs optional Neovim Python and Node integrations

### ⚠️ Warning

This script:

- Performs a full system upgrade

- Removes previous Neovim installs

- Purges XDG Neovim directories

It is intended for:

- Ubuntu environments

- Users who understand what a clean rebuild implies

- Reproducible dev setups

> The script is intentionally opinionated and not designed as a general-purpose installer.
>
> If you just want the configuration, cloning the repo is sufficient.

---

## 🧩 Inspiration & References

This setup borrows ideas from:

- Neovim core documentation
- lazy.nvim examples
- real-world debugging and iteration
- learning where not to be clever
