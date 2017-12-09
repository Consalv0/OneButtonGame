require "Math"
local Object = require "Object"
local Physics = require "Physics"

GameObject = {
  -- Draw Variables --
  sprite = love.graphics.newImage(love.image.newImageData(1, 1)),
  scale = scale or 1,
  color = {0, 0, 0, 0},
  -- Physics Variables --
  collisions = 0,
  rigidBody = Physics.NONE,

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
  obj.scale = scale
  return obj
end

function GameObject:getDimensions()
  return self.sprite:getWidth() * self.scale,
         self.sprite:getHeight() * self.scale
end
function GameObject:getWidth()
  return self.sprite:getWidth() * self.scale
end
function GameObject:getHeight()
  return self.sprite:getHeight() * self.scale
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

function GameObject:onCollisionStay(other, sides)
  if (bit.band(sides, Physics.CLEFT  ) > 0) then self.velX = math.abs(self.velX) end
  if (bit.band(sides, Physics.CRIGHT ) > 0) then self.velX = -math.abs(self.velX) end
  if (bit.band(sides, Physics.CTOP   ) > 0) then self.velY = math.abs(self.velY) end
  if (bit.band(sides, Physics.CBOTTOM) > 0) then self.velY = -math.abs(self.velY) end

  if bit.band(self.rigidBody, Physics.DYNAMIC) > 0 and other and other.posX then
    self.posX = self.posX + (bit.band(sides, Physics.CRIGHT  ) > 0 and -self.posX - self:getWidth() + other.posX or
      bit.band(sides, Physics.CLEFT ) > 0 and -self.posX + other.posX + other:getWidth() or 0)
    self.posY = self.posY + (bit.band(sides, Physics.CBOTTOM) > 0 and -self.posY - self:getHeight() + other.posY or
      bit.band(sides, Physics.CBOTTOM) > 0 and -self.posY + other.posY + other:getHeight() or 0)
  end
end

function GameObject:onCollisionExit(other, sides)

end

function GameObject:draw()
  love.graphics.setColor(self.color)
  love.graphics.draw(self.sprite, math.floor(self.posX / 6.62) * 6.62,
    math.floor(self.posY/ 6.62) * 6.62, 0, self.scale, self.scale)
  love.graphics.setColor(255, 255, 255, 255)
end
