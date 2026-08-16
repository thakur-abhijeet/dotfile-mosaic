-- ╔══════════════════════════════════════════╗
-- ║         Neovim — configs/lazy.lua        ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝

return {

    -- ===========================================================================
    -- Defaults
    -- ===========================================================================
    defaults = {
        lazy = true,
    },

    -- ===========================================================================
    -- Rocks — disabled (no plugins require luarocks)
    -- ===========================================================================
    rocks = {
        enabled = false,
        hererocks = false,
    },

    -- ===========================================================================
    -- Install
    -- ===========================================================================
    install = {
        colorscheme = { "nvchad" },
    },

    -- ===========================================================================
    -- UI
    -- ===========================================================================
    ui = {
        icons = {
            ft = "",
            lazy = "󰂠 ",
            loaded = "",
            not_loaded = "",
        },
    },

    -- ===========================================================================
    -- Change Detection
    -- ===========================================================================
    change_detection = {
        enabled = true,
        notify = false,
    },

    -- ===========================================================================
    -- Performance
    -- ===========================================================================
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            -- Add nvim data/site to runtimepath so treesitter parsers are found
            paths = {
                vim.fn.stdpath "data" .. "/site",
            },
            disabled_plugins = {
                "2html_plugin",
                "bugreport",
                "compiler",
                "ftplugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "netrw",
                "netrwFileHandlers",
                "netrwPlugin",
                "netrwSettings",
                "optwin",
                "rplugin",
                "rrhelper",
                "spellfile_plugin",
                "synmenu",
                "syntax",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
}
