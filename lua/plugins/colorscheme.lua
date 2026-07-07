return {
    {
        "rmehri01/onenord.nvim",
        priority = 1000,
        config = function()
            require("onenord").setup({
                theme = "light",
            })

            require("onenord").load()
        end,
    },
}

