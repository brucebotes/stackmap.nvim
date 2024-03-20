P = function(v)
  print(vim.inspect(v))
end

RELOAD = function(...)
  return require("plenary.reload").reload.module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

--[[ rPrint(struct, [limit], [indent])   Recursively print arbitrary data.
	Set limit (default 100) to stanch infinite loops.
	Indents tables as [KEY] VALUE, nested tables as [KEY] [KEY]...[KEY] VALUE
	Set indent ("") to prefix each line:    Mytable [KEY] [KEY]...[KEY] VALUE
--]]
function RPrint(s, l, i) -- recursive Print (structure, limit, indent)
  l = l or 100
  i = i or ""            -- default item limit, indent string
  if l < 1 then
    print("ERROR: Item limit reached.")
    return l - 1
  end
  local ts = type(s)
  if ts ~= "table" then
    print(i, ts, s)
    return l - 1
  end
  print(i, ts)           -- print "table"
  for k, v in pairs(s) do -- print "[KEY] VALUE"
    l = RPrint(v, l, i .. "  [" .. tostring(k) .. "]")
    if l < 0 then
      break
    end
  end
  return l
end

