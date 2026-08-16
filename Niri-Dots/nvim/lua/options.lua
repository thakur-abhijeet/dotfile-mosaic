-- ╔══════════════════════════════════════════╗
-- ║         Neovim — options.lua             ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝

-- Load NvChad defaults first
require "nvchad.options"

local o = vim.o
local g = vim.g
local opt = vim.opt

-- =============================================================================
-- Cursor
-- =============================================================================
o.cursorline = true
o.cursorlineopt = "both" -- highlight line number + line

-- =============================================================================
-- Line Numbers
-- =============================================================================
o.number = true
o.relativenumber = true -- relative + absolute hybrid (best for motion)
o.numberwidth = 2

-- =============================================================================
-- Indentation
-- =============================================================================
o.tabstop = 4      -- 4 spaces = 1 tab (Java convention)
o.shiftwidth = 4
o.expandtab = true -- spaces not tabs
o.smartindent = true
o.autoindent = true

-- =============================================================================
-- Search
-- =============================================================================
o.ignorecase = true -- case-insensitive search
o.smartcase = true  -- ...unless you type uppercase
o.hlsearch = true
o.incsearch = true

-- =============================================================================
-- Splits
-- =============================================================================
o.splitbelow = true -- horizontal splits open below
o.splitright = true -- vertical splits open right

-- =============================================================================
-- Wrapping & Scrolling
-- =============================================================================
o.wrap = false  -- no line wrap (important for wide Java files)
o.scrolloff = 8 -- keep 8 lines above/below cursor
o.sidescrolloff = 8

-- =============================================================================
-- Appearance
-- =============================================================================
o.termguicolors = true
o.showmode = false    -- mode shown in statusline (NvChad handles it)
o.signcolumn = "yes"  -- always show — prevents layout shift on LSP
o.colorcolumn = "120" -- Java line length guide (Google style = 100, Oracle = 80)

-- =============================================================================
-- Files & Undo
-- =============================================================================
o.undofile = true  -- persistent undo across sessions
o.undolevels = 10000
o.swapfile = false -- no swap files (you have undofile)
o.backup = false

-- =============================================================================
-- Performance
-- =============================================================================
o.updatetime = 250 -- faster CursorHold (LSP diagnostics)
o.timeoutlen = 400 -- faster which-key popup

-- =============================================================================
-- Misc
-- =============================================================================
o.mouse = "a"           -- mouse support (useful for resizing splits)
o.pumheight = 10        -- max items in completion popup
o.fileencoding = "utf-8"
o.confirm = true        -- ask to save instead of failing
o.virtualedit = "block" -- free cursor in visual block mode
