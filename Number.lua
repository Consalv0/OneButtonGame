require "Character"
require "GameObject"
local Object = require "Object"

Number = {
  number = 0,
  digits = {}
}
Number = GameObject:extend("Number", Number)

function Number:init(length, base, negativeSymbol)
  local inst = {}
  setmetatable(inst, self)
  self.__index = self
  for i = 1, length do
    inst.digits[i] = Character:new(Object.copy(base))
    inst.digits[i].posX = (length - (i - 1)) * inst.scale
  end
  inst.color = base.color
  inst.scale = base.scale
  return inst
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
  for i = 1, #self.digits do
    self.digits[i]:setDigit(getDigitAtPos(self.number, i - 1))
  end
  if self.number < 0 then self.digits[#self.digits]:setValue('-') end
end

function Number:draw()
  love.graphics.setColor(self.color)
  for i = 1, #self.digits do
    love.graphics.draw(self.digits[i].sprite,
      math.floor((self.posX) / 6.62) * 6.62 + (#self.digits - i) * (self.digits[i].sprite:getWidth() * self.scale + self.scale),
      math.floor(self.posY / 6.62) * 6.62, 0, self.scale, self.scale)
  end
  love.graphics.setColor(255, 255, 255, 255)
end
