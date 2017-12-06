local Object = require "Object"

local Sprite = {}

function Sprite:init(data)
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  obj = Sprite.dataToSprites(Object.copy(data))
  return obj
end

function Sprite:addSprite(name, data, category)
  if category ~= nil then
    self[category] = self[category] or {}
    self[category][name] = createSprite(data)
  else
    self[name] = createSprite(data)
  end
end

function Sprite.isData(t)
  for key, value in pairs(t) do
    if type(value) == 'table' then
      if type(key) ~= 'number' then return false end -- Is not number, no useful
      for ikey, ivalue in pairs(value) do -- Check if second dimension is table
        if (type(ivalue) == 'table') then return false end
      end
    else
      return false
    end
  end
  return true
end

function Sprite.createSprite(data)
  if data == nil then return data end
  local sprite = love.image.newImageData(#data[1], #data)
  local temp = 0;
  for i=0, #data[1] -1 do  -- remember: start at 0 not 1
    for j=0, #data -1 do
      temp = data[j+1][i+1] / 9 -- 0 is transparent, 1-9 -> black-white
      sprite:setPixel(i, j, temp * 255, temp * 255, temp * 255, temp == 0 and 0 or 255)
    end
  end
  return love.graphics.newImage(sprite)
end

function Sprite.dataToSprites(sData)
  sData = sData -- Copy initial data
  for key, value in pairs(sData) do
    if type(value) == 'table' then
      if Sprite.isData(value) then -- Check if the next two dimensions are numbers
        sData[key] = Sprite.createSprite(sData[key])
      else
        Sprite.dataToSprites(value, sData) -- Recursivity inside the inner value
      end
    else
      sData[key] = nil -- Value is no useful
    end
  end
  return sData
end

return Sprite
