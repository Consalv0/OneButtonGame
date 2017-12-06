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
