return {
    {
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        opts = {
            keymap = {
                preset = "default",
                    ["<CR>"] = { "accept", "fallback" },
                    ["<Tab>"] = { "select_next", "fallback" },
                    ["<S-Tab>"] = { "select_prev", "fallback" },
                    ["<Down>"] = { "select_next", "fallback" },
                    ["<Up>"] = { "select_prev", "fallback" },
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 300,
                },
            },

            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },

            signature = {
                enabled = true,
            },
        },
    },
}
