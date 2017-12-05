require "GameObject"

Digit = GameObject:new()
Digit.sprites = {}
Digit.number = 0

function Digit:new(obj)
  obj = obj or {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function Digit:new(sprites, scale, value)
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  obj.sprites = sprites
  obj.scale = scale
  obj:setNumber(value or self.number)
  return obj
end

function Digit:setNumber(value)
  self.number = math.floor(value) % 10
  self.sprite = self.sprites[self.number]
end
function Digit:getNumber()
  return self.number
end
