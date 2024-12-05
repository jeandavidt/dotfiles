-- this is a comment 
local number = 5
local string = "hello world!"
local single = 'also works'
local lines = [[this is 
multi-line]]

-- function syntax 1 
local function hello(name)
  print('Hello, ' ..  name .. "!")
end

-- function syntax 2
local greet = function(name)
  print('Hello, ' ..  name .. "!")
end

local truth, lies = true, false
local nothing = nil

-- higher-order functions are allowed (closures, decorators)

-- data structures - all based around the table
--
local list = {"first", 2, false, funciton(), print("Fourth!")}
print(list[1]) -- first




