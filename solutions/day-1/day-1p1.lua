local math = require('math')
local aoc = require('aoc')

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end


---Calculates the distance between two lists
---@param first table first list 
---@param second table second list
---@return integer distance the distance between the lists
local function distance_of_lists(first, second)
  local first_c = table.shallow_copy(first)
  local second_c = table.shallow_copy(second)
  table.sort(first_c)
  table.sort(second_c)

  -- store distances
  local distances = {}

  -- calculate the distance between each item
  for i,_ in ipairs(first_c) do
    distances[i] = math.abs(first_c[i] - second_c[i])
  end

  -- sum up the distances between the elements
  local total_distance = 0
  for _,k in ipairs(distances) do
    total_distance = total_distance + k
  end
  return total_distance
end

local input1, input2 = {}, {}

-- get input for day 1
for line in aoc.get_input_by_line(1) do
  local n1, n2 = line:match('^(%d+).-(%d+)$')
  table.insert(input1, n1)
  table.insert(input2, n2)
end

-- execute for today's input
local solution = distance_of_lists(input1, input2)
print("Solution: ", solution)