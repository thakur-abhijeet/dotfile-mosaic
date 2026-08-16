-- ╔══════════════════════════════════════════╗
-- ║         Neovim — configs/lspconfig.lua   ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝
-- Neovim 0.11+ uses vim.lsp.config / vim.lsp.enable directly
-- Mason handles installation: :MasonInstall <server>
-- Check status: :LspInfo

-- =============================================================================
-- NvChad LSP defaults (keymaps, handlers, capabilities)
-- =============================================================================
require("nvchad.configs.lspconfig").defaults()

-- =============================================================================
-- Servers — simple (no custom config needed)
-- =============================================================================
local servers = {
  "html", -- HTML
  "cssls", -- CSS
  "ts_ls", -- TypeScript / JavaScript
  "bashls", -- Bash / Shell scripts
  "pyright", -- Python
  "rust_analyzer", -- Rust
  "taplo", -- TOML
  "dockerls", -- Dockerfile
  "docker_compose_language_service", -- docker-compose.yml
}

vim.lsp.enable(servers)

-- =============================================================================
-- Lua — Neovim-aware config
-- =============================================================================
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library",
        },
      },
      diagnostics = {
        globals = { "vim" }, -- suppress "undefined global vim" warnings
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

vim.lsp.enable "lua_ls"

-- =============================================================================
-- YAML — schema support (GitHub Actions, docker-compose, Spring)
-- =============================================================================
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*.yml",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.yml",
        ["https://json.schemastore.org/spring-boot-project.json"] = "application*.yml",
      },
      validate = true,
      completion = true,
      hover = true,
    },
  },
})

vim.lsp.enable "yamlls"

-- =============================================================================
-- JSON — schema support (schemastore.nvim, pcall-guarded)
-- =============================================================================
vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = (function()
        local ok, schemastore = pcall(require, "schemastore")
        if ok then
          return schemastore.json.schemas()
        end
        return {}
      end)(),
      validate = { enable = true },
    },
  },
})

vim.lsp.enable "jsonls"

-- =============================================================================
-- Java — handled by nvim-jdtls (ftplugin/java.lua)
-- DO NOT add java here — jdtls manages its own lifecycle
-- =============================================================================

-- =============================================================================
-- Diagnostic display
-- =============================================================================
vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false, -- no diagnostics while typing
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
}
