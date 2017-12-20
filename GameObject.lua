require "Math"
local Object = require "Object"
local Physics = require "Physics"

GameObject = {
  -- Draw Variables --
  sprite = nil,
  color = {255, 255, 255, 255},
  -- Physics Variables --
  collisions = 0,
  rigidBody = Physics.NONE,

  scaleX = scaleX or 1,
  scaleY = scaleY or 1,
  posX = 0, posY = 0,
  velX = 0, velY = 0
}

GameObject = Object:extend("GameObject", GameObject)

-- Constrcutor --
function GameObject:init(sprite, scale)
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  obj.sprite = sprite
  obj.scaleX = scale
  obj.scaleY = scale
  return obj
end

function GameObject:getDimensions()
  if self.sprite == nil then return 0, 0 end
  return self.sprite:getWidth() * self.scaleX,
         self.sprite:getHeight() * self.scaleY
end
function GameObject:getWidth()
  if self.sprite == nil then return 0 end
  return self.sprite:getWidth() * self.scaleX
end
function GameObject:getHeight()
  if self.sprite == nil then return 0 end
  return self.sprite:getHeight() * self.scaleY
end

function GameObject:getPosition()
  return self.posX, self.posY
end
function GameObject:setPosition(x, y)
  self.posX = x
  self.posY = y
end

function GameObject:getVelocity()
  return self.velX, self.velY
end
function GameObject:setVelocity(x, y, vel)
  if vel ~= nil then
    x, y = math.normalize(x, y)
    x = x * vel
    y = y * vel
  end
  self.velX = x
  self.velY = y
end

function GameObject:update(dt)
  -- Movement --
  dt = dt * 10
  self.posX = self.posX + self.velX * dt
  self.posY = self.posY + self.velY * dt
end

function GameObject:onCollisionEnter(other, sides)
  if (bit.band(sides, Physics.CLEFT  ) > 0) then self.velX = math.abs(self.velX) end
  if (bit.band(sides, Physics.CRIGHT ) > 0) then self.velX = -math.abs(self.velX) end
  if (bit.band(sides, Physics.CTOP   ) > 0) then self.velY = math.abs(self.velY) end
  if (bit.band(sides, Physics.CBOTTOM) > 0) then self.velY = -math.abs(self.velY) end
end

-- TODO change velocity not position
function GameObject:onCollisionStay(other, sides)
  local repulse = math.dist(self.posX + self:getWidth() * 0.5, self.posY + self:getHeight() * 0.5,
                             other.posX + other:getWidth() * 0.5, other.posY + other:getHeight() * 0.5)
  repulse = (1 / (repulse * repulse)) * 1000
  -- if bit.band(self.rigidBody, Physics.DYNAMIC) > 0 and other and other.posX then
  --   self.posX = self.posX + (bit.band(sides, Physics.CRIGHT ) > 0 and -1
  --                           or bit.band(sides, Physics.CLEFT) > 0 and 1 or 0) * repulse
  --   self.posY = self.posY + (bit.band(sides, Physics.CBOTTOM) > 0 and -1
  --                           or bit.band(sides, Physics.CTOP ) > 0 and 1 or 0) * repulse
  -- end
  if bit.band(self.rigidBody, Physics.DYNAMIC) > 0 and other and other.posX then
    self.posX = self.posX + (bit.band(sides, Physics.CRIGHT ) > 0 and -self.posX - self:getWidth() + other.posX or
      bit.band(sides, Physics.CLEFT ) > 0 and -self.posX + other.posX + other:getWidth() or 0) * repulse
    self.posY = self.posY + (bit.band(sides, Physics.CBOTTOM) > 0 and -self.posY - self:getHeight() + other.posY or
      bit.band(sides, Physics.CTOP ) > 0 and -self.posY + other.posY + other:getHeight() or 0) * repulse
  end
end

function GameObject:onCollisionExit(other, sides)

end

function GameObject:draw()
  if self.sprite == nil then return end
  love.graphics.setColor(self.color)
  self.sprite:draw(math.floor(self.posX / 6.62) * 6.62,
    math.floor(self.posY/ 6.62) * 6.62, 0, self.scaleX, self.scaleY)
  love.graphics.setColor(255, 255, 255, 255)
end
