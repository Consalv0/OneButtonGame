require "SpritesData"

Sprites = {}

function Sprites:new(data)
  obj = {}
  setmetatable(obj, self)
  self.__index = self
  obj = createSprites(data)
  return obj
end

function Sprites:addSprite(name, data, category)
  if category ~= nil then
    self[category] = self[category] or {}
    self[category][name] = createSprite(data)
  else
    self[name] = createSprite(data)
  end
end

function isData(t)
  for key, value in pairs(t) do
    if type(value) == 'table' then
      if type(key) ~= 'number' then return false end
      for ikey, ivalue in pairs(value) do
        if (type(ivalue) == 'table') then return false end
      end
    else
      return false
    end
  end
  return true
end

function createSprites(sData, sprites)
  sprites = sData
  for key, value in pairs(sData) do
    if type(value) == 'table' then
      if isData(value) then
        sprites[key] = createSprite(sprites[key])
      else
        createSprites(value, sprites)
      end
      for k, v in pairs(value) do
        print(key, k, v)
      end
    else
      sprites[key] = nil
    end
  end
  return sprites
end


function createSprite(data)
  sprite = love.image.newImageData(#data[1], #data)
  temp = 0;
  for i=0, #data[1] -1 do  -- remember: start at 0 not 1
    for j=0, #data -1 do
      temp = data[j+1][i+1] / 9
      sprite:setPixel(i, j, temp * 255, temp * 255, temp * 255, temp == 0 and 0 or 255)
    end
  end
  img = love.graphics.newImage(sprite)
  return img
end
