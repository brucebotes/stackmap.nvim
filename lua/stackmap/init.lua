local find_mapping = function(maps, lhs)
	for _, value in ipairs(maps) do
		if value.lhs == lhs then
			return value
		end
	end
end

local M = {}

M._stack = {}

M.push = function(name, mode, mappings)
	local maps = vim.api.nvim_get_keymap(mode)

	local existing_maps = {}
	for lhs, rhs in pairs(mappings) do
		local existing = find_mapping(maps, lhs)
		if existing then
			existing_maps[lhs] = existing
		end
	end

	for lhs, rhs in pairs(mappings) do
		-- TODO: find a way to pass in options
		vim.keymap.set(mode, lhs, rhs)
	end

  -- ensure this name is made before
  M._stack[name] = M._stack[name] or {}

	M._stack[name][mode] = {
		existing = existing_maps,
		mappings = mappings,
	}
end

M.pop = function(name, mode)
	local state = M._stack[name][mode]
	M._stack[name][mode] = nil

	for lhs in pairs(state.mappings) do
		if state.existing[lhs] then
			-- handle mappinmgs that existed
			local original_mapping = state.existing[lhs]

			-- TODO: find a way to pass in options
			vim.keymap.set(mode, lhs, original_mapping.rhs)
		else
			-- handle mappings that did not exist
			vim.keymap.del(mode, lhs)
		end
	end
end

M.push("debug_mode", "n", {
	[" st"] = "echo 'Hello'",
	[" sz"] = "echo 'Goodbye'",
})

M._clear = function()
	M._stack = {}
end

--[[
lua require("stackmap").push(debug_mode, "n", {
  ["<leader>st"] = "echo 'Hello'",
  ["<leader>sz"] = "echo 'Goodbye'",

})
]]
--

--[[
lua require("stackmap").mappings(debug_mode)
]]
--
return M
