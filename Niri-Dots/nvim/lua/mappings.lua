-- ╔══════════════════════════════════════════╗
-- ║         Neovim — mappings.lua            ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝

-- Load NvChad defaults first
require "nvchad.mappings"

local map = vim.keymap.set

-- =============================================================================
-- Core
-- =============================================================================

-- Semicolon enters command mode (saves reaching for colon)
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Quick escape from insert mode
map("i", "jk", "<ESC>", { desc = "Escape insert mode" })

-- Save file
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })

-- Save without formatting (bypass autocmd format-on-save)
map("n", "<leader>sn", "<cmd>noautocmd w<cr>", { desc = "Save without formatting" })

-- Quit
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- =============================================================================
-- Better Defaults
-- =============================================================================

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Keep cursor centered when searching
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- Don't yank on paste in visual mode
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Don't yank on delete
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Better indenting — stay in visual mode
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down in visual mode
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up" })

-- =============================================================================
-- Window Management
-- =============================================================================

-- Split windows
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split vertical" })
map("n", "<leader>wh", "<cmd>split<cr>", { desc = "Split horizontal" })
map("n", "<leader>we", "<cmd>wincmd =<cr>", { desc = "Equalize splits" })
map("n", "<leader>wx", "<cmd>close<cr>", { desc = "Close split" })

-- Navigate splits with Ctrl+hjkl
map("n", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Focus left split" })
map("n", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Focus right split" })
map("n", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Focus down split" })
map("n", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Focus up split" })

-- Resize splits with Alt+arrows
map("n", "<A-Up>", "<cmd>resize +2<cr>", { desc = "Resize up" })
map("n", "<A-Down>", "<cmd>resize -2<cr>", { desc = "Resize down" })
map("n", "<A-Left>", "<cmd>vertical resize -2<cr>", { desc = "Resize left" })
map("n", "<A-Right>", "<cmd>vertical resize +2<cr>", { desc = "Resize right" })

-- =============================================================================
-- Buffers
-- =============================================================================

map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- =============================================================================
-- LSP  (supplement NvChad defaults)
-- =============================================================================

map("n", "<leader>lf", vim.lsp.buf.format, { desc = "LSP format" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP rename" })
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP code action" })
map("n", "<leader>ld", vim.lsp.buf.definition, { desc = "LSP definition" })
map("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "LSP declaration" })
map("n", "<leader>li", vim.lsp.buf.implementation, { desc = "LSP implementation" })
map("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "LSP type definition" })
map("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP hover" })
map("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "LSP signature" })

-- Diagnostics navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>le", vim.diagnostic.open_float, { desc = "Diagnostic float" })

-- =============================================================================
-- Git  (supplement gitsigns / NvChad)
-- =============================================================================

map("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Git blame" })
map("n", "<leader>gd", "<cmd>Git diff<cr>", { desc = "Git diff" })
map("n", "<leader>gl", "<cmd>Git log<cr>", { desc = "Git log" })
map("n", "<leader>gs", "<cmd>Git status<cr>", { desc = "Git status" })
map("n", "<leader>gp", "<cmd>Git push<cr>", { desc = "Git push" })

-- =============================================================================
-- Misc
-- =============================================================================

-- Clear search highlight
map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear search highlight" })

-- Toggle line wrap
map("n", "<leader>tw", "<cmd>set wrap!<cr>", { desc = "Toggle wrap" })

-- Toggle relative numbers
map("n", "<leader>tn", "<cmd>set rnu!<cr>", { desc = "Toggle relative numbers" })

-- Open current file's directory in oil/netrw
map("n", "<leader>e", "<cmd>Ex<cr>", { desc = "Open file explorer" })

-- Reload config
map("n", "<leader>rc", "<cmd>source $MYVIMRC<cr>", { desc = "Reload config" })
