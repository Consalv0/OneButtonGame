
Sprite = {
  atlas = nil,
  quad = nil,
  name = ''
}

function Sprite:init(image, name, x, y, w, h)
  local s = {}
  setmetatable(s, self)
  self.__index = self
  s.atlas = image
  s.quad = love.graphics.newQuad(x, y, w, h, image:getDimensions())
  s.name = name
  s.w = w
  s.h = h
  return s
end

function Sprite:draw(x, y, r, scaleX, scaleY)
  love.graphics.draw(self.atlas, self.quad, x, y, r, scaleX, scaleY)
end

function Sprite:getDimensions()
  return self.w, self.h
end
function Sprite:getWidth()
  return self.w
end
function Sprite:getHeight()
  return self.h
end

return Sprite
