-- ╔══════════════════════════════════════════╗
-- ║         Neovim — chadrc.lua              ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝
-- NvChad UI config — structure must match:
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

-- =============================================================================
-- Theme
-- =============================================================================
local colors = require "custom_colors"

M.base46 = {
    theme = "tokyonight", -- keeping the name but overriding colors
    theme_toggle = { "tokyonight", "one_light" },

    changed_themes = {
        tokyonight = {
            base_16 = colors,
        },
    },

    hl_override = {
        Comment = { italic = true, fg = colors.base03 },
        ["@comment"] = { italic = true },
        ["@keyword"] = { italic = true, fg = colors.base08 },
        ["@keyword.return"] = { italic = true, fg = colors.base08 },
        ["@type.builtin"] = { italic = true },
    },

    hl_add = {
        FloatBorder = { fg = colors.base0D },
        NormalNC = { bg = colors.base01 },
    },

    transparency = false,
}

-- =============================================================================
-- Dashboard
-- =============================================================================
M.nvdash = {
    load_on_startup = true,
    header = {
        "                                                    ",
        " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "                                                    ",
        "          Abhijeet · NvChad · Custom Theme            ",
        "                                                    ",
    },
    buttons = {
        { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
        { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
        { txt = "  Find Word", keys = "fw", cmd = "Telescope live_grep" },
        { txt = "  Bookmarks", keys = "bm", cmd = "Telescope marks" },
        { txt = "  Config", keys = "nc", cmd = "e $MYVIMRC" },
        { txt = "  Lazy", keys = "lz", cmd = "Lazy" },
        { txt = "󰗼  Quit", keys = "qq", cmd = "qa" },
    },
}

-- =============================================================================
-- UI
-- =============================================================================
M.ui = {
    tabufline = {
        lazyload = false, -- load tabline immediately
        order = { "treeOffset", "buffers", "tabs", "btns" },
    },

    statusline = {
        theme = "default",
        separator_style = "round",
    },

    cmp = {
        icons_left = true, -- show kind icons on the left
        style = "flat",
    },

    telescope = {
        style = "bordered",
    },
}

-- =============================================================================
-- LSP
-- =============================================================================
M.lsp = {
    signature = true, -- show function signature while typing
}

return M
