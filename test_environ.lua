core = {}

function core.global_exists(name)
	return false
end

dofile('/home/joachim/minetest4/builtin/common/vector.lua')
dofile('/home/joachim/minetest4/builtin/common/misc_helpers.lua')

safer_lua = {}
dofile('/home/joachim/minetest4/mods/techpack/safer_lua/data_struct.lua')
dofile('/home/joachim/minetest4/mods/techpack/safer_lua/scanner.lua')
dofile('/home/joachim/minetest4/mods/techpack/safer_lua/environ.lua')

--local Cache = {}
--local key = minetest.pos_to_hash(pos)
--code = Cache[key]

local function foo(self, val)
	print("Hallo", val)
end	

local function error(pos, s)
	print("[Test] "..(s or "").." at pos "..dump(pos))
end


local init = "fo"
local loop = [[
  --$loopcycle(5)
  --$events(true)
  $foo("hallo")
  $foo("hallo")
  $foo(math.floor(5.5))
  $foo("Joe")
  a = Store()
  a.set("a", 123)
  a.set("b", 456)  
  $foo(a.get("a"))  
  $foo(ticks)  
  if ticks == 10 then $foo("Fehler") end
  for k,v in a.next() do
    $foo(k)  
  end
  --for k = 1,4,1 do
  --  next = 3  
  --  $foo(k)  
  --end
  --$foo(meta.pos)  
]]

local init2 = [[
meme = "\n\n\"" while true do end meme = ""
]]

local env = {foo = foo}
env.meta = {pos=1, owner="Joe", number="0123"}

local code = safer_lua.init(0, init, "", loop, env, error)
if code then
	print(safer_lua.run_loop(0, 0, code, error))
	safer_lua.run_loop(0, 1, code, error)
	safer_lua.run_loop(0, 2, code, error)
end

print("\n<<< Coroutine >>>\n")
local function outp(self, val)
	print(val)
end	

local function step(self, num)
	for i=1,num do
		print(i)
		coroutine.yield()
	end
end	


local thread = [[
    $outp("hallo")
    $step(2) 
	$outp(meta.pos)
]]

env = {step = step, outp = outp}

env.meta = {pos=1, owner="Joe", number="0123", error=error}
local co, code = safer_lua.co_create(0, init, thread, env, error)

if code then
	for i=1,20 do
		if safer_lua.co_resume(0, co, code, error) == false then break end
	end
end
