local http = require('socket.http')
local ltn12 = require('ltn12')

local f = string.format

local aoc = {}

local function try_read(path)
   local file = io.open(path, 'r')

   if not file then
      return nil
   end

   return file
end

function aoc.get_input(day)
   local path = f('inputs/day-%s.txt', day)
   local file = try_read(path)

   if file then
      local contents = file:read('*a')

      file:close()

      return contents
   end

   local buff = {}

   local r, c, h = http.request({
      url = f('https://adventofcode.com/2024/day/%s/input', day),
      method = 'GET',
      headers = {
         cookie = f('session=%s', os.getenv('AOC_SESSION'))
      },
      sink = ltn12.sink.table(buff)
   })

   if not r then
      error(c)
   end

   if c < 200 or c > 299 then
      io.stderr:write(f('Body: %s\nCode: %s\nHeaders:\n', table.concat(buff), c))
      for i, v in pairs(h) do
         io.stderr:write(f('  %s: %s\n', i, v))
      end
      io.stderr:write('Failed to get puzzle\n')
      os.exit(-1)
   end

   local body = table.concat(buff)

   file = assert(io.open(path, 'w'))
   assert(file:write(body))

   return body
end

function aoc.get_input_by_line(day)
   local file = try_read(f('inputs/day-%s.txt', day))

   if not file then
      aoc.get_input(day)
      return aoc.get_input_by_line(day)
   end

   local lines = file:lines('l')

   return function()
      local line = lines()

      if not line then
         file:close()
         return nil
      end

      return line
   end
end

return aoc