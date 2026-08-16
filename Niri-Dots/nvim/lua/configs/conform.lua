-- ╔══════════════════════════════════════════╗
-- ║         Neovim — configs/conform.lua     ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝
-- Formatters are auto-installed via mason-conform
-- Install manually: :ConformInfo to check status

local options = {

  -- ===========================================================================
  -- Formatters by filetype
  -- ===========================================================================
  formatters_by_ft = {

    -- Neovim
    lua = { "stylua" },

    -- Web (uncomment when prettier is installed: npm i -g prettier)
    html       = { "prettier" },
    css        = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json       = { "prettier" },
    yaml       = { "prettier" },
    markdown   = { "prettier" },

    -- Java — formatting handled by jdtls LSP (google-java-format)
    -- conform hands off to LSP via lsp_fallback below
    java = { "google-java-format" },

    -- Shell scripts
    sh   = { "shfmt" },
    bash = { "shfmt" },

    -- Python
    python = { "black" },

    -- Rust
    rust = { "rustfmt" },

    -- SQL  (your PostgreSQL native queries)
    sql = { "sqlfluff" },

    -- Config files
    toml = { "taplo" },
  },

  -- ===========================================================================
  -- Format on save
  -- ===========================================================================
  format_on_save = function(bufnr)
    -- Disable for files larger than 1MB (performance)
    local max_filesize = 1024 * 1024
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats and stats.size > max_filesize then
      return
    end

    -- Disable for specific filetypes
    local disabled_filetypes = { "oil", "TelescopePrompt" }
    if vim.tbl_contains(disabled_filetypes, vim.bo[bufnr].filetype) then
      return
    end

    return {
      timeout_ms   = 2000,
      lsp_fallback = true,   -- fall back to LSP if no conform formatter found
    }
  end,

  -- ===========================================================================
  -- Formatter config overrides
  -- ===========================================================================
  formatters = {
    shfmt = {
      prepend_args = { "-i", "4" },   -- 4 space indent for shell scripts
    },
    sqlfluff = {
      args = { "fix", "--dialect", "postgres", "-" },
    },
    prettier = {
      prepend_args = {
        "--tab-width", "2",
        "--single-quote",
        "--trailing-comma", "all",
      },
    },
  },
}

return options
