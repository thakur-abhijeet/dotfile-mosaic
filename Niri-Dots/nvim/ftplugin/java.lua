-- ╔══════════════════════════════════════════╗
-- ║         Neovim — ftplugin/java.lua       ║
-- ║         Abhijeet · NvChad v2.5           ║
-- ╚══════════════════════════════════════════╝
-- Auto-sourced by Neovim when a .java file opens
-- jdtls manages its own lifecycle — do NOT add java to lspconfig

local jdtls = require "jdtls"
local jdtls_dir = vim.fn.stdpath "data" .. "/mason/packages/jdtls"
local java_home = os.getenv "JAVA_HOME"
    or "/usr/lib/jvm/java-21-openjdk"     -- CachyOS fallback
    or "/usr/lib/jvm/java-21-openjdk-amd64" -- Ubuntu fallback

-- =============================================================================
-- Workspace — per-project data dir
-- Each project gets its own jdtls workspace so they don't conflict
-- =============================================================================
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace = vim.fn.stdpath "data" .. "/jdtls-workspace/" .. project_name

-- =============================================================================
-- Capabilities — merge nvim-cmp completion with jdtls
-- =============================================================================
local capabilities = require("nvchad.configs.lspconfig").capabilities or vim.lsp.protocol.make_client_capabilities()

-- =============================================================================
-- Bundles — optional extras (debug + test)
-- Install via Mason: :MasonInstall java-debug-adapter java-test
-- =============================================================================
local bundles = {}

local debug_path = vim.fn.glob(
    vim.fn.stdpath "data" .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    true
)
if debug_path ~= "" then
    vim.list_extend(bundles, { debug_path })
end

vim.list_extend(
    bundles,
    vim.split(
        vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/java-test/extension/server/*.jar", true),
        "\n",
        { trimempty = true }
    )
)

-- =============================================================================
-- jdtls config
-- =============================================================================
local config = {

    cmd = {
        java_home .. "/bin/java",

        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.level=ALL",
        "-Xmx2g", -- 2GB heap — enough for Spring Boot projects
        "-jar",
        vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        jdtls_dir .. "/config_linux",
        "-data",
        workspace,
    },

    root_dir = require("jdtls.setup").find_root {
        "pom.xml",  -- Maven (your Spring Boot projects)
        "build.gradle", -- Gradle
        "build.gradle.kts",
        ".git",
    },

    capabilities = capabilities,

    -- ===========================================================================
    -- jdtls-specific settings
    -- ===========================================================================
    settings = {
        java = {
            home = java_home,

            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            references = { includeDecompiledSources = true },

            -- Compiler
            configuration = {
                updateBuildConfiguration = "interactive",
                runtimes = {
                    { name = "JavaSE-21", path = java_home },
                },
            },

            -- Code style
            format = {
                enabled = true,
                settings = {
                    -- Use google-java-format style
                    -- Download: https://github.com/google/google-java-format
                    url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },

            -- Inlay hints — show param names and types inline
            inlayHints = {
                parameterNames = {
                    enabled = "all", -- "none" | "literals" | "all"
                },
            },

            -- Import organization
            saveActions = {
                organizeImports = true,
            },

            -- Lombok support  (your Spring Boot project uses it)
            -- mason installs lombok.jar automatically with jdtls
            jvm_args = {
                "-javaagent:" .. jdtls_dir .. "/lombok.jar",
            },

            completion = {
                favoriteStaticMembers = {
                    "org.junit.jupiter.api.Assertions.*",
                    "org.mockito.Mockito.*",
                    "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
                    "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
                },
                filteredTypes = {
                    "com.sun.*",
                    "io.micrometer.shaded.*",
                    "java.awt.*",
                    "jdk.*",
                    "sun.*",
                },
            },

            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },

            codeGeneration = {
                toString = {
                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                },
                useBlocks = true, -- use {} blocks in if/else even for single lines
            },
        },
    },

    -- ===========================================================================
    -- Extra bundles (debug + test)
    -- ===========================================================================
    init_options = {
        bundles = bundles,
    },

    -- ===========================================================================
    -- Java-specific keymaps (only active in Java buffers)
    -- ===========================================================================
    on_attach = function(client, bufnr)
        -- Enable jdtls extras if debug bundle loaded
        jdtls.setup_dap { hotcodereplace = "auto" }
        require("jdtls.dap").setup_dap_main_class_configs()

        local opts = { buffer = bufnr, silent = true }
        local map = vim.keymap.set

        -- Code actions
        map("n", "<leader>jo", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Java organize imports" }))
        map("n", "<leader>jv", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Java extract variable" }))
        map("n", "<leader>jc", jdtls.extract_constant, vim.tbl_extend("force", opts, { desc = "Java extract constant" }))
        map("v", "<leader>jm", function()
            jdtls.extract_method(true)
        end, vim.tbl_extend("force", opts, { desc = "Java extract method" }))
        map(
            "n",
            "<leader>jt",
            jdtls.test_nearest_method,
            vim.tbl_extend("force", opts, { desc = "Java test nearest method" })
        )
        map("n", "<leader>jT", jdtls.test_class, vim.tbl_extend("force", opts, { desc = "Java test class" }))
        map(
            "n",
            "<leader>ju",
            "<cmd>JdtUpdateConfig<cr>",
            vim.tbl_extend("force", opts, { desc = "Java update jdtls config" })
        )
        map("n", "<leader>jb", "<cmd>JdtBytecode<cr>", vim.tbl_extend("force", opts, { desc = "Java show bytecode" }))
    end,
}

-- =============================================================================
-- Start jdtls
-- =============================================================================
jdtls.start_or_attach(config)
