core = {}

function core.global_exists(name)
	return false
end

safer_lua = {}

dofile('/home/joachim/minetest4/builtin/common/vector.lua')
dofile('/home/joachim/minetest4/builtin/common/misc_helpers.lua')
dofile('/home/joachim/minetest4/mods/techpack/safer_lua/scanner.lua')

code = [[
-- GOOD
a = 1
a = a + 1
print(a)
foo(a)

-- BAD
_G.print(()
t = {}
for i = 1,1000 do
]]

code2 = [[
meme = "\"" while true do end meme = ""
]]

code3 = "s = [[abc]]"
local function error(pos, s)
	print("[Robbi] "..s)
end

safer_lua:check(nil, code, "Code", error)

lToken = safer_lua:scanner(code2)
safer_lua:check(nil, code2, "Code", error)

lToken = safer_lua:scanner(code3)
safer_lua:check(nil, code3, "Code", error)
