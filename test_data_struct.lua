core = {}

function core.global_exists(name)
	return false
end

dofile('/home/joachim/minetest4/builtin/common/vector.lua')
dofile('/home/joachim/minetest4/builtin/common/misc_helpers.lua')

safer_lua = {}
safer_lua.MaxTableSize = 1000   -- number of table entries considering string lenghts

dofile('/home/joachim/minetest4/mods/techpack/safer_lua/data_struct.lua')


print("Array")
local a = safer_lua.Array(1,2,3,4)  --> {1,2,3,4}
a.add(6)               --> {1,2,3,4,6}
a.set(2, 8)            --> {1,8,3,4,6}
a.insert(5,7)          --> {1,8,3,4,7,6}
print(dump(a.__dump()))
a.remove(3)            --> {1,8,4,7,6}
a.insert(1, "hello")   --> {"hello",1,8,4,7,6}
print(a.size())        --> function returns 10
print(dump(a.__dump()))


print("Store")
local s = safer_lua.Store()            --> {}
s.set("val", 12)       --> {val = 12}
s.get("val")           --> returns 12
s.set(0, "hello")      --> {val = 12, [0] = "hello"}
print(dump(s.__dump()))
s.del("val")           --> {[0] = "hello"}
print(s.size())        --> function returns 6


print("Set")
s = safer_lua.Set("Tom", "Lucy", "Joe") --> {Tom = true, Lucy = true, Joe = true}
s.add("Susi")                     --> {Tom = true, Lucy = true, Joe = true, Susi = true}
s.del("Tom")                      --> {Lucy = true, Joe = true, Susi = true}
print(dump(s.__dump()))
print(s.has("Joe"))               --> function returns `true`
print(s.has("Mike"))              --> function returns `false`
print(s.size())                   --> function returns 11

print("S1")
local s1 = safer_lua.Store()
assert(s1.size() == 0)

s1.a = 3
s1[1] = 4
assert(s1.size() == 0)

s1.set("b", "Hallo")
assert(s1.size() == 1)
assert(s1.memsize() == 6)

s1.set("b", "Hall")
assert(s1.size() == 1)
assert(s1.memsize() == 5)


assert(s1.get("b") == "Hall")
assert(s1.size() == 1)

s1.set("1234", "12345678")
assert(s1.size() == 2)
assert(s1.memsize() == 17)

s1.del("1234")
print(s1.size())
assert(s1.size() == 1)
assert(s1.memsize() == 5)
assert(s1.get("1234") == nil)

print("S2")
local s2 = safer_lua.Store()
assert(s2.size() == 0)
assert(s2.memsize() == 0)
s2.set("b", "Joe")
assert(s2.size() == 1)
assert(s2.memsize() == 4)

assert(s2.b == nil)
assert(s2.get('b') == "Joe")
s2.c = "XXX!"
assert(s2.c == nil)

s1.set("c", s2)
print(dump(s1.get("c")))
assert(s1.size() == 2)
print(s1.memsize())
assert(s1.memsize() == 10)
assert(s2.size() == 1)
assert(s2.memsize() == 4)


print("A1")
local a1 = safer_lua.Array(1,2,3,4)
assert(a1.size() == 4)
print(dump(a1))
a1.set(2, "Hallo")
assert(a1.size() == 4)
assert(a1.memsize() == 8)
a1.insert(1, 0)
assert(a1.size() == 5)
assert(a1.memsize() == 9)
a1.remove(3)
assert(a1.size() == 4)
assert(a1.memsize() == 4)

print(a1.MemSize)
print(a1.Size)


print("Set")
local s3 = safer_lua.Set("Joe", "Bob", "Tom")
print(s3.size())
s3.add("Susi")
local t = s3.__dump()
print(dump(t))
s3.del("Tom")
assert(s3.has("Susi") == true)
assert(s3.has("Mike") == false)
print(s3.size())
assert(s3.size() == 3)
assert(s3.memsize() == 10)


local s4 = safer_lua.Set()
s4.__load(3, 12, {Joe=true, Bob=true, Tom=true})
assert(s4.has("Joe") == true)
assert(s4.has("Mike") == false)
print(s4.size())
assert(s4.size() == 3)
assert(s4.memsize() == 12)


local tbl = safer_lua.datastruct_to_table(s3)
s3 = safer_lua.table_to_datastruct(tbl)
assert(s3.has("Susi") == true)
assert(s3.has("Mike") == false)
print(s3.size())
assert(s3.size() == 3)
assert(s3.memsize() == 10)


tbl = safer_lua.datastruct_to_table(a1)
a1 = safer_lua.table_to_datastruct(tbl)
assert(a1.size() == 4)
assert(a1.memsize() == 4)
assert(a1.get(4) == 4)


tbl = safer_lua.datastruct_to_table(s2)
s2 = safer_lua.table_to_datastruct(tbl)
assert(s2.size() == 1)
assert(s2.memsize() == 4)
assert(s2.get("b") == "Joe")


print("next over Array")
local a2 = safer_lua.Array(10, 20, 30)
for i,v in a2.next() do
    print(i,v)
end
	
print("next over Set")
local s6 = safer_lua.Set("Joe", "Bob", "Tom")
for i,v in s6.next() do
    print(i,v)
end

print("next over Store")
local s7 = safer_lua.Store()            --> {}
s7.set("a", 12)  
s7.set("b", 13)  
s7.set("c", 14)  
for k,v in s7.next() do
    print(k,v)
end

print("sort")
a3 = safer_lua.Array("Joe", "Bob", "Tom")
a3.sort(true)
print(dump(a3.__dump()))
a3.sort()
print(dump(a3.__dump()))

s7 = safer_lua.Store()
s7.set("Joe", 1000)
s7.set("Susi", 800)
s7.set("Tom", 60)
s7.set("Mike", 900)
s7.set("Bob", 1100)
local k = s7.keys()
print(dump(k.__dump()))
local k = s7.keys("up")
print(dump(k.__dump()))
local k = s7.keys("down")
print(dump(k.__dump()))

