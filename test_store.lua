core = {}

function core.global_exists(name)
	return false
end

dofile('/home/joachim/minetest/builtin/common/vector.lua')
dofile('/home/joachim/minetest/builtin/common/misc_helpers.lua')

safer_lua = {}
safer_lua.MaxTableSize = 1000   -- number of table entries considering string lenghts

dofile('/home/joachim/minetest4/mods/techpack/safer_lua/data_struct.lua')

local s1 = safer_lua.Store()
local s2 = safer_lua.Store()

print("S1")
assert(s1.size() == 0)

s1.a = 3
assert(s1.size() == 0)

s1.set("b", "Hallo")
assert(s1.size() == 1)

assert(s1.get("b") == "Hallo")
assert(s1.size() == 1)

print("S2")
assert(s2.size() == 0)
s2.set("b", "Joe")
assert(s2.size() == 1)

assert(s2.b == nil)
s2.c = "XXX!"
assert(s2.c == nil)

s1.set("c", s2)
print(s1.get("c"))


local s3 = safer_lua.Store("a", 4, "b", 5, "c")
assert(s3.get("a") == 4)
assert(s3.get("b") == 5)
assert(s3.get("c") == nil)

s = safer_lua.Store("a", 4, "b", 5)    --> {a = 4, b = 5}
--s = safer_lua.Store()    --> {a = 4, b = 5}
s.set("val", 12)       --> {a = 4, b = 5, val = 12}
s.get("val")           --> returns 12
s.set(0, "hello")      --> {a = 4, b = 5, val = 12, [0] = "hello"}
s.del("val")           --> {a = 4, b = 5, [0] = "hello"}
print(s.size())               --> function returns 3
print(s.memsize())            --> function returns 8



print("Ready.")