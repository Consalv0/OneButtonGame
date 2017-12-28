require "Math"
local Object = require "Object"
local Physics = require "Physics"

GameObject = {
  -- Draw Variables --
  sprite = nil,
  color = {255, 255, 255, 255},
  -- Physics Variables --
  collisions = 0,
  bounciness = -0.9,
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
  obj.id = Object.UUID()
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
  -- Gravity --
  if bit.band(self.rigidBody, Physics.DYNAMIC) > 0 then
    self.velY = self.velY + Physics.gravity * dt
  end
  -- Movement --
  self.posX = self.posX + self.velX * dt
  self.posY = self.posY + self.velY * dt
end

function GameObject:onCollisionEnter(other, sides, dt)
  if (bit.band(sides, Physics.CLEFT  ) > 0) then self.velX = -math.abs(self.velX) * self.bounciness end
  if (bit.band(sides, Physics.CRIGHT ) > 0) then self.velX = math.abs(self.velX) * self.bounciness end
  if (bit.band(sides, Physics.CTOP   ) > 0) then self.velY = -math.abs(self.velY) * self.bounciness end
  if (bit.band(sides, Physics.CBOTTOM) > 0) then self.velY = math.abs(self.velY) * self.bounciness end
end

-- TODO change velocity not position
function GameObject:onCollisionStay(other, sides, dt)

  if bit.band(self.rigidBody, Physics.DYNAMIC) > 0 then
    if (bit.band(sides, Physics.CLEFT  ) > 0) then self.velX = self.velX + dt * 1000 end
    if (bit.band(sides, Physics.CRIGHT ) > 0) then self.velX = self.velX - dt * 1000 end
    if (bit.band(sides, Physics.CTOP   ) > 0) then self.velY = self.velY + dt * 1000 end
    if (bit.band(sides, Physics.CBOTTOM) > 0) then self.velY = self.velY - dt * 1000 end
  end

  local moveX, moveY
  if bit.band(self.rigidBody, Physics.DYNAMIC) > 0 and other and other.posX then
    moveX = bit.band(sides, Physics.CRIGHT ) > 0 and -self.posX - self:getWidth() + other.posX or
      bit.band(sides, Physics.CLEFT ) > 0 and -self.posX + other.posX + other:getWidth() or 0
    moveY = bit.band(sides, Physics.CBOTTOM) > 0 and -self.posY - self:getHeight() + other.posY or
      bit.band(sides, Physics.CTOP ) > 0 and -self.posY + other.posY + other:getHeight() or 0
    moveX = math.clamp(moveX, -math.abs(self.velX), math.abs(self.velX))
    moveY = math.clamp(moveY, -math.abs(self.velY), math.abs(self.velY))
    self.posX = self.posX + moveX
    self.posY = self.posY + moveY
  end

  self.velX = self.velX * (1 - dt)
  self.velY = self.velY * (1 - dt)
end

function GameObject:onCollisionExit(other, sides, dt)

end

function GameObject:draw()
  if self.sprite == nil then return end
  love.graphics.setColor(self.color)
  self.sprite:draw(self.posX, self.posY, 0, self.scaleX, self.scaleY)
  love.graphics.setColor(255, 255, 255, 255)
end
