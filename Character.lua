require "GameObject"

Character = {
  chars = {},
  value = 0
}
Character = GameObject:extend("Character", Character)

function Character:init(chars, scale, value)
  local inst = {}
  setmetatable(inst, self)
  self.__index = self
  inst.chars = chars
  inst.scaleX = scale
  inst.scaleY = scale
  inst:setValue(value or self.value)
  return inst
end

-- General --
function Character:setValue(value)
  self.value = value
  self.sprite = self.chars[tostring(self.value)]
end

-- Digit --
function Character:setDigit(value)
  self.value = value
  self.sprite = self.chars[tostring(math.floor(self.value % 10))]
end
function Character:addDigit(value)
  if type(self.value) ~= 'number' then self.value = 0 end
  self.value = self.value + value
  self.sprite = self.chars[tostring(math.floor(self.value % 10))]
end

-- Other --
function Character:getValue()
  return self.value
end
