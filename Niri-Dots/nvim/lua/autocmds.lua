-- ╔══════════════════════════════════════════╗
-- ║         Neovim — autocmds.lua            ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝

require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local function group(name)
    return augroup(name, { clear = true })
end

-- =============================================================================
-- Editor Feel
-- =============================================================================

autocmd("TextYankPost", {
    group    = group "highlight_yank",
    desc     = "Highlight yanked region",
    callback = function()
        vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
    end,
})

autocmd("BufWritePre", {
    group    = group "trim_whitespace",
    desc     = "Remove trailing whitespace on save",
    pattern  = "*",
    callback = function()
        local pos = vim.api.nvim_win_get_cursor(0)
        vim.cmd [[%s/\s\+$//e]]
        vim.api.nvim_win_set_cursor(0, pos)
    end,
})

autocmd("BufReadPost", {
    group    = group "restore_cursor",
    desc     = "Restore cursor to last position",
    callback = function()
        local mark       = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- =============================================================================
-- Window Behavior
-- =============================================================================

autocmd("VimResized", {
    group    = group "resize_splits",
    desc     = "Equalize splits on resize",
    callback = function()
        vim.cmd "tabdo wincmd ="
    end,
})

autocmd("FileType", {
    group    = group "quick_close",
    desc     = "Close utility windows with q",
    pattern  = {
        "help", "lspinfo", "man", "notify",
        "qf", "startuptime", "checkhealth", "query",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true,
            desc   = "Close window",
        })
    end,
})

-- =============================================================================
-- Filetype — Indentation
-- =============================================================================

autocmd("FileType", {
    group    = group "java_indent",
    desc     = "Java: 4 space indent",
    pattern  = "java",
    callback = function()
        vim.opt_local.tabstop    = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab  = true
    end,
})

autocmd("FileType", {
    group    = group "web_indent",
    desc     = "Web/config files: 2 space indent",
    pattern  = { "html", "css", "javascript", "typescript", "json", "yaml", "toml", "kdl" },
    callback = function()
        vim.opt_local.tabstop    = 2
        vim.opt_local.shiftwidth = 2
    end,
})

autocmd("FileType", {
    group    = group "sql_indent",
    desc     = "SQL: 2 space indent",
    pattern  = { "sql", "mysql", "plsql" },
    callback = function()
        vim.opt_local.tabstop    = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- =============================================================================
-- Filetype — Docker Compose detection
-- =============================================================================

autocmd({ "BufRead", "BufNewFile" }, {
    group    = group "docker_compose_ft",
    desc     = "Set filetype for docker-compose files",
    pattern  = { "docker-compose*.yml", "docker-compose*.yaml", "compose*.yml" },
    callback = function()
        vim.bo.filetype = "yaml.docker-compose"
    end,
})

-- =============================================================================
-- LSP
-- =============================================================================

autocmd("BufWritePre", {
    group    = group "lsp_format",
    desc     = "Auto-format on save via LSP",
    callback = function()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        for _, client in ipairs(clients) do
            if client.supports_method "textDocument/formatting" then
                vim.lsp.buf.format { async = false, timeout_ms = 2000 }
                return
            end
        end
    end,
})

autocmd("CursorHold", {
    group    = group "lsp_diagnostic_hover",
    desc     = "Show diagnostics on cursor hold",
    callback = function()
        vim.diagnostic.open_float(nil, {
            focusable    = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border       = "rounded",
            source       = "always",
            prefix       = " ",
        })
    end,
})

-- =============================================================================
-- Git
-- =============================================================================

autocmd("FileType", {
    group    = group "git_commit",
    desc     = "Git commit: wrap at 72 chars + spellcheck",
    pattern  = "gitcommit",
    callback = function()
        vim.opt_local.textwidth   = 72
        vim.opt_local.colorcolumn = "72"
        vim.opt_local.spell       = true
    end,
})
