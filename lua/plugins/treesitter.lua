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
            local ts = require("nvim-treesitter")
            ts.setup({})

            local installed = ts.get_installed()
            local to_install = vim.tbl_filter(function(p)
                return not vim.tbl_contains(installed, p)
            end, parsers)
            if #to_install > 0 then
                ts.install(to_install)
            end

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
