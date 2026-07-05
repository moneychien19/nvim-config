vim.keymap.set("n", "<leader>f", function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
    })
end, {
    desc = "Format file",
})
