return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",

        opts = {
            preset = "modern",
            delay = 200,
            spec = {
                { "<leader>f", group = "Find" },
                { "<leader>l", group = "LSP" },
                { "<leader>c", group = "Code" },
                { "<leader>g", group = "Git" },
                { "<leader>t", group = "Terminal" },
            },
        },
    },
}
