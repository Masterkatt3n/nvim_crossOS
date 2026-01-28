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

- **PowerShell (PSES)**  
  Content around the PowerShell LSP was somewhat scarce or outdated when I started.  
  I do most of my work in PowerShell, so these settings may be useful to others.

---

## 🖥 Supported Platforms

- Windows 11 (native Neovim)
- WSL (Ubuntu)
- Linux (tested on Ubuntu-based systems)

> The same config is expected to work on all of the above without modification.

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
lua/
├── config/
│   ├── lsp/
│   │   ├── capabilities.lua
│   │   ├── helpers.lua
│   │   └── semantic_cmp.lua
│   ├── diagnostics.lua
│   ├── keymaps.lua
│   ├── options.lua
│   └── lazy.lua
├── plugins/
│   ├── lsp.lua
│   ├── lua.lua
│   ├── lualine.lua
│   └── ...
└── types/
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

## 🧩 Inspiration & References

This setup borrows ideas from:

- Neovim core documentation
- lazy.nvim examples
- real-world debugging and iteration
- learning where not to be clever
