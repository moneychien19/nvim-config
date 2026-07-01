local parsers = {
    "c",
    "lua",
    "python",
    "markdown",
    "markdown_inline",
    "yaml",
    "json",
}

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",

        config = function()
            require("nvim-treesitter").setup({})

            require("nvim-treesitter").install(parsers)

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                    if not lang then
                        return
                    end

                    pcall(vim.treesitter.start, args.buf, lang)
                end,
            })
        end,
    },
}
