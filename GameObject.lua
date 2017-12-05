GameObject = {
  -- Draw Variables --
  sprite = love.graphics.newImage(love.image.newImageData(1, 1)),
  localScale = scale or 1,
  baseColor = {0, 0, 0, 0},
  -- Pysics Variables --
  collisions = 0,
  rigidBody = nil,
  position = {0, 0},
  velocity = {0, 0}
}

-- Constrcutors --
function GameObject:new(obj)
  obj = obj or {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function GameObject:new(sprite, scale)
  obj = {}
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
