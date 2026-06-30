local builtin = require("telescope.builtin")

vim.keymap.set("n", "gd", builtin.lsp_definitions)
vim.keymap.set("n", "gr", builtin.lsp_references)
vim.keymap.set("n", "gi", builtin.lsp_implementations)
vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols)
