
local json = require("json4lua")
local Sprite = require("Sprite")

local Sprites = {}

function Sprites:init(imageURL, dataURL)
  local s = {}
  setmetatable(s, self)
  self.__index = self

  local image = love.graphics.newImage(imageURL)
  local info, size = love.filesystem.read(dataURL)
  info = json.decode(info)

  for i = 1, #info.meta.slices do
    -- print(info.meta.slices[i].name)
    local bounds = info.meta.slices[i].keys[1].bounds
    s[info.meta.slices[i].name] = Sprite:init(image, bounds['x'], bounds['y'], bounds['w'], bounds['h'])
  end
  return s
end
--[[
local Object = require "Object"

function Sprites.isData(t)
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

function Sprites.createSprites(data)
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

function Sprites.dataToSprites(sData)
  sData = sData -- Copy initial data
  for key, value in pairs(sData) do
    if type(value) == 'table' then
      if Sprites.isData(value) then -- Check if the next two dimensions are numbers
        sData[key] = Sprites.createSprites(sData[key])
      else
        Sprites.dataToSprites(value, sData) -- Recursivity inside the inner value
      end
    else
      sData[key] = nil -- Value is no useful
    end
  end
  return sData
end
--]]

return Sprites
