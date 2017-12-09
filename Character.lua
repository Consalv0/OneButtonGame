require "GameObject"

Character = {
  sprites = {},
  value = 0
}
Character = GameObject:extend("Character", Character)

function Character:init(sprites, scale, value)
  local inst = {}
  setmetatable(inst, self)
  self.__index = self
  inst.sprites = sprites
  inst.scale = scale
  inst:setValue(value or self.value)
  return inst
end

-- General --
function Character:setValue(value)
  self.value = value
  self.sprite = self.sprites[self.value]
end

-- Digit --
function Character:setDigit(value)
  self.value = value
  self.sprite = self.sprites[math.floor(self.value % 10)]
end
function Character:addDigit(value)
  if type(value) == 'number' then
    if type(self.value) ~= 'number' then self.value = 0 end
    self.value = self.value + value
    self.sprite = self.sprites[math.floor(self.value % 10)]
  end
end

-- Other --
function Character:getValue()
  return self.value
end

function Character:onCollisionStay(other, sides)
  if bit.band(sides, Physics.CLEFT  ) > 0 then self.velX = math.abs(self.velX) end
  if bit.band(sides, Physics.CRIGHT ) > 0 then self.velX = -math.abs(self.velX) end
  if bit.band(sides, Physics.CTOP   ) > 0 then self.velY = math.abs(self.velY) end
  if bit.band(sides, Physics.CBOTTOM) > 0 then self.velY = -math.abs(self.velY) end

  if bit.band(self.rigidBody, Physics.DYNAMIC) > 0 and other and other.posX then
    self.posX = self.posX + (bit.band(sides, Physics.CRIGHT  ) > 0 and -self.posX - self:getWidth() + other.posX or
      bit.band(sides, Physics.CLEFT ) > 0 and -self.posX + other.posX + other:getWidth() or 0)
    self.posY = self.posY + (bit.band(sides, Physics.CBOTTOM) > 0 and -self.posY - self:getHeight() + other.posY or
      bit.band(sides, Physics.CBOTTOM) > 0 and -self.posY + other.posY + other:getHeight() or 0)
  end
  self:addDigit(1)
end
