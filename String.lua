
require "GameObject"
local Object = require "Object"
local Character = require "Character"

String = {
  value = '',
  chars = {}
}
String = GameObject:extend("String", String)

function String:init(chars, scale, value)
  local inst = {}
  setmetatable(inst, self)
  self.__index = self
  inst.id = Object.UUID()
  inst.chars = chars
  inst.scaleX = scale
  inst.scaleY = scale
  inst.value = value
  return inst
end

function String:getDimensions()
  return self:getWidth(), self:getHeight()
end
function String:getWidth()
  local width = 0
  for c in self.value:gmatch"." do
    if self.chars[c] ~= nil then
      width = width + self.chars[c]:getWidth() * self.scaleX
    else
      width = width + self.chars[' ']:getWidth() * self.scaleX
    end
  end
  return width
end
function String:getHeight()
  return self.chars[' ']:getHeight() * self.scaleY
end

function String:draw()
  love.graphics.setColor(self.color)
  local width = 0
  for c in self.value:gmatch"." do
    if self.chars[c] ~= nil then
      self.chars[c]:draw(
        math.floor((self.posX) / 6.62) * 6.62 + width,
        math.floor(self.posY / 6.62) * 6.62, 0, self.scaleX, self.scaleY)
      width = width + self.chars[c]:getWidth() * self.scaleX
    else
      self.chars[' ']:draw(
        math.floor((self.posX) / 6.62) * 6.62 + width,
        math.floor(self.posY / 6.62) * 6.62, 0, self.scaleX, self.scaleY)
      width = width + self.chars[' ']:getWidth() * self.scaleX
    end
  end
  love.graphics.setColor(255, 255, 255, 255)
end

return String
