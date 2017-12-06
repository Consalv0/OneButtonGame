local Object = {}

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
  return init
end

function Object:extend(name, t)
  t = t or {}
  t.__index = t
  t.super = self
  return setmetatable(t, { __call = self.new, __index = self })
end

function Object:init()
end

return Object
