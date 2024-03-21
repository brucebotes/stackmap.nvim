print("hello bruce")

vim.keymap.set("n", "<leader>st", ":echo 'hello'")
-- trigger test from the opened buffer cantaining the test code
vim.keymap.set("n", "<leader>t", "<Plug>PlenaryTestFile")
