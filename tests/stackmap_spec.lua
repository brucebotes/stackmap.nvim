-- Note this uses the plenary.nvim plugin
-- mapp the key <leader>t to <Plug>PlenaryTestFile with
-- :nmap <leader>t <Plug>PlenaryTestFile
-- and the while this file is open, execute <leader>t

local find_mapping = function(lhs)
	local maps = vim.api.nvim_get_keymap("n")

	for _, value in ipairs(maps) do
		if value.lhs == lhs then
			return value
		end
	end
end

describe("stackmap", function()
	before_each(function()
		require("stackmap")._clear()
		pcall(vim.keymap.del, "n", "asdfgh")
		pcall(vim.keymap.del, "n", "asdfgh_1")
		pcall(vim.keymap.del, "n", "asdfgh_2")
	end)

	it("can be required", function()
		require("stackmap")
	end)

	it("can push a single mapping", function()
		local rhs = "echo 'This is a test'"
		require("stackmap").push("test1", "n", {
			asdfgh = rhs,
		})

		local found = find_mapping("asdfgh")
		assert.are.same(rhs, found.rhs)
	end)

	it("can push a mutiple mappings", function()
		local rhs = "echo 'This is a test'"
		require("stackmap").push("test1", "n", {
			["asdfgh_1"] = rhs .. "_1",
			["asdfgh_2"] = rhs .. "_2",
		})

		local found1 = find_mapping("asdfgh_1")
		assert.are.same(rhs .. "_1", found1.rhs)

		local found2 = find_mapping("asdfgh_2")
		assert.are.same(rhs .. "_2", found2.rhs)
	end)

	it("can delete mappings with pop: no existing", function()
		local rhs = "echo 'This is a test'"
		require("stackmap").push("test1", "n", {
			asdfgh = rhs,
		})

		local found = find_mapping("asdfgh")
		assert.are.same(rhs, found.rhs)

		-- local debugging tip
		-- assert.are.same({}, require("stackmap")._stack)

		require("stackmap").pop("test1", "n")
		found = find_mapping("asdfgh")
		assert.are.same(nil, found)
	end)

	it("can delete mappings with pop: yes existing", function()
		vim.keymap.set("n", "asdfgh", "echo 'Original Mapping'")

		local rhs = "echo 'This is a test'"
		require("stackmap").push("test1", "n", {
			asdfgh = rhs,
		})

		local found = find_mapping("asdfgh")
		assert.are.same(rhs, found.rhs)

		-- local debugging tip
		-- assert.are.same({}, require("stackmap")._stack)

		require("stackmap").pop("test1", "n")
		found = find_mapping("asdfgh")
		assert.are.same("echo 'Original Mapping'", found.rhs)
	end)
end)
