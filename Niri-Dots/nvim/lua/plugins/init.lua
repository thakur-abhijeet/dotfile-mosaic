-- ╔══════════════════════════════════════════╗
-- ║         Neovim — plugins/init.lua        ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝

return {

    -- Formatting
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = require "configs.conform",
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    -- JSON Schema Store
    {
        "b0o/schemastore.nvim",
        lazy = true,
    },

    -- Java
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
    },

    -- Git
    {
        "tpope/vim-fugitive",
        cmd = { "Git", "G" },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "󰍵" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "▎" },
            },
            current_line_blame = true,
            current_line_blame_opts = { delay = 500 },
        },
    },

    -- File Explorer
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        keys = {
            { "<leader>e", "<cmd>Oil<cr>", desc = "Oil file explorer" },
        },
        opts = {
            default_file_explorer = true,
            view_options = { show_hidden = true },
        },
    },

    -- Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            defaults = {
                prompt_prefix = "❯ ",
                selection_caret = "❯ ",
                path_display = { "smart" },
            },
        },
    },

    -- Auto close HTML tags
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts = {},
    },

    -- Surround motions
    {
        "kylechui/nvim-surround",
        event = "BufReadPre",
        version = "*",
        opts = {},
    },

    -- Better w/b/e for camelCase + snake_case
    {
        "chrisgrieser/nvim-spider",
        keys = {
            { "w", "<cmd>lua require('spider').motion('w')<cr>", mode = { "n", "o", "x" }, desc = "Spider w" },
            { "e", "<cmd>lua require('spider').motion('e')<cr>", mode = { "n", "o", "x" }, desc = "Spider e" },
            { "b", "<cmd>lua require('spider').motion('b')<cr>", mode = { "n", "o", "x" }, desc = "Spider b" },
        },
    },

    -- Better UI for vim.ui.select / input
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {},
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        main = "ibl",
        opts = {
            indent = { char = "▏" },
            scope = { enabled = true },
        },
    },

    -- Markdown Preview
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_theme = "dark"
        end,
    },

    -- Diagnostics list
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
        },
    },

    -- Fast navigation
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
        },
    },

    -- Todo comments highlighting
    {
        "folke/todo-comments.nvim",
        event = "BufReadPre",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    -- Color highlighter
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPre",
        opts = {
            user_default_options = {
                tailwind = true,
                RRGGBBAA = true,
                AARRGGBB = true,
            }
        },
    },

    -- Session management
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = {},
        keys = {
            { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
            { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
        },
    },
}
