-- ╔══════════════════════════════════════════╗
-- ║         Neovim — init.lua                ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝

-- =============================================================================
-- NvChad base46 theme cache
-- =============================================================================
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

-- =============================================================================
-- Leader key  (must be set before lazy)
-- =============================================================================
vim.g.mapleader = " "

-- =============================================================================
-- Bootstrap lazy.nvim
-- =============================================================================
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git", "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- Load plugins via lazy.nvim
-- =============================================================================
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy   = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, require "configs.lazy")

-- =============================================================================
-- Clipboard — Wayland (wl-clipboard)
-- Works on both machines (Hyprland + Niri both use wl-clipboard)
-- =============================================================================
vim.g.clipboard = {
  name          = "wl-clipboard",
  copy          = { ["+"] = "wl-copy",                    ["*"] = "wl-copy"                    },
  paste         = { ["+"] = "wl-paste --no-newline",      ["*"] = "wl-paste --no-newline"      },
  cache_enabled = 1,
}

vim.opt.clipboard = "unnamedplus"

-- =============================================================================
-- Load base46 theme cache  (NvChad theming)
-- =============================================================================
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

-- =============================================================================
-- Load core modules
-- =============================================================================
require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
