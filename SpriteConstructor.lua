function createSprite(data)
  sprite = love.image.newImageData(#data[1], #data)
  for i=0, #data[1] -1 do   -- remember: start at 0 not 1
    for j=0, #data -1 do
      sprite:setPixel(i, j, (data[j+1][i+1] / 9) * 255, (data[j+1][i+1] / 9) * 255, (data[j+1][i+1] / 9) * 255, data[j+1][i+1] * 255)
    end
  end
  img = love.graphics.newImage(sprite)
  return img
end
