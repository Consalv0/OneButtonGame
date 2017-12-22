require "Character"
require "GameObject"
local Object = require "Object"

Number = {
  number = 0,
  chars = {}
}
Number = GameObject:extend("Number", Number)

function Number:init(length, base)
  local inst = {}
  setmetatable(inst, self)
  self.__index = self
  inst.id = Object.UUID()
  for i = 1, length do
    inst.chars[i] = Character:new(Object.copy(base))
    inst.chars[i].posX = (length - (i - 1)) * inst.scaleX
  end
  inst.color = base.color
  inst.scaleX = base.scale
  inst.scaleY = base.scale
  return inst
end

function Number:getHeight()
  return self.chars[1].sprite:getHeight() * self.scaleY
end
function Number:getWidth()
  local width = 0
  for i = 1, #self.chars do
    width = width + self.chars[i].sprite:getWidth() * self.scaleX
  end
  return width
end

local function getDigitAtPos(num, index)
  num = math.abs(num);
  if index > 0 then
    return math.floor((num % math.pow(10, index + 1)) / math.pow(10, index));
  else
    return math.floor(num % math.pow(10, index + 1));
  end
end

function Number:update(dt)
  -- Movement --
  dt = dt * 10
  self.posX = self.posX + self.velX * dt
  self.posY = self.posY + self.velY * dt

  -- Assign Numbers --
  for i = 1, #self.chars do
    self.chars[i]:setDigit(getDigitAtPos(self.number, i - 1))
  end
  if self.number < 0 then self.chars[#self.chars]:setValue('-') end
end

function Number:draw()
  love.graphics.setColor(self.color)
  local width = self:getWidth()
  for i = 1, #self.chars do
    width = width - self.chars[i].sprite:getWidth() * self.scaleX
    self.chars[i].sprite:draw(
      math.floor((self.posX) / 6.62) * 6.62 + width,
      math.floor(self.posY / 6.62) * 6.62, 0, self.scaleX, self.scaleY)
  end
  love.graphics.setColor(255, 255, 255, 255)
end
