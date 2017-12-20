
require "GameObject"
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
  inst.chars = chars
  inst.scaleX = scale
  inst.scaleY = scale
  inst.value = value
  return inst
end

function String:draw()
  love.graphics.setColor(self.color)
  local width = 0
  for c in self.value:gmatch"." do
    if self.chars[c] ~= nil then
      self.chars[c]:draw(
        self.posX + width,
        self.posY, 0, self.scaleX, self.scaleY)
      width = width + self.chars[c]:getWidth() * self.scaleX
    else
      self.chars[' ']:draw(
        self.posX + width,
        self.posY, 0, self.scaleX, self.scaleY)
      width = width + self.chars[' ']:getWidth() * self.scaleX
    end
  end
  love.graphics.setColor(255, 255, 255, 255)
end

return String
