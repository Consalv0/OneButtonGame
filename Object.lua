local Object = {
  __type = 'object',
  id = '00000000-0000-0000-0000-000000000000'
}

math.randomseed(os.clock()+os.time())
local random = math.random
function Object.UUID()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
    local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
    return string.format('%x', v)
  end)
end

function Object.copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[Object.copy(k, s)] = Object.copy(v, s) end
  return res
end

function Object:new(obj)
  local init = obj or {}
  setmetatable(init, self)
  self.__index = self
  init.id = Object.UUID()
  return init
end

function Object:extend(name, t)
  t = t or {}
  t.__index = t
  t.super = self
  t.id = Object.UUID()
  return setmetatable(t, { __call = self.new, __index = self })
end

function Object:init()
  self.id = Object.UUID()
end

return Object
