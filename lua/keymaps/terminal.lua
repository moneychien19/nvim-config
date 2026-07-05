local terminal_buf = nil
local terminal_win = nil

local function toggle_terminal()
    if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
        vim.api.nvim_win_close(terminal_win, true)
        terminal_win = nil
        return
    end

    vim.cmd("botright 15split")

    if terminal_buf and vim.api.nvim_buf_is_valid(terminal_buf) then
        vim.api.nvim_win_set_buf(0, terminal_buf)
    else
        vim.cmd("terminal")
        terminal_buf = vim.api.nvim_get_current_buf()
    end

    terminal_win = vim.api.nvim_get_current_win()
    vim.cmd("startinsert")
end

vim.keymap.set({ "n", "t" }, "<C-/>", toggle_terminal, {
    desc = "Toggle terminal",
})
