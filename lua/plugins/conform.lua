return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },

        opts = {
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
        },
    },
}
