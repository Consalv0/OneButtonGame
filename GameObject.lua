require "Math"

GameObject = {
  -- Draw Variables --
  sprite = love.graphics.newImage(love.image.newImageData(1, 1)),
  scale = scale or 1,
  color = {0, 0, 0, 0},
  -- Physics Variables --
  collisions = 0,
  rigidBody = nil,
  posX = 0,
  posY = 0,
  velX = 0,
  velY = 0
}

-- Constrcutors --
function GameObject:new(obj)
  local obj = obj or {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function GameObject:new(sprite, scale)
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  obj.sprite = sprite
  obj.scale = scale
  return obj
end

function GameObject:dimensions()
  return self.sprite:getWidth() * self.scale,
         self.sprite:getHeight() * self.scale
end
function GameObject:width()
  return self.sprite:getWidth() * self.scale
end
function GameObject:height()
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
  dt = dt * 10
  self.posX = self.posX + self.velX * dt
  self.posY = self.posY + self.velY * dt
end

function GameObject:onCollisionEnter(other, sides)

end

function GameObject:onCollisionExit(other, sides)

end

function GameObject:draw()
  love.graphics.setColor(self.color)
  love.graphics.draw(self.sprite, math.floor(self.posX / 6.62) * 6.62, self.posY, 0, self.scale, self.scale)
  love.graphics.setColor(255, 255, 255, 255)
end
