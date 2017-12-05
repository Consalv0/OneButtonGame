require "Sprites"
require "GameObject"

-- Bitwise operations --
local bit = require("bit")

function love.load()
  -- Default Values for the screen --
  love.window.setMode(1000, 800, { resizable=true, vsync=false, minwidth=400, minheight=400 })
  love.window.setTitle("One <Button> Game")

  -- Default filters --
  love.graphics.setDefaultFilter('nearest', 'nearest', 0)
  love.graphics.setLineWidth(2)

  -- Game canvas initializer --
  canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight(), "rgba8", 0)
  love.graphics.setCanvas(canvas)
  love.graphics.setBlendMode('alpha', 'alphamultiply')

  -- PostFX shaders --
  myShader = love.graphics.newShader("CRT.frag")

  -- Test variables --
  sprites = Sprites:new(SpritesData)
  -- love.errhand("Hola")
  obj = GameObject:new(testImg, 10)
end

-- Update is called here
function love.update(deltaTime)

end

-- Draw all you need here.
function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  love.graphics.setBackgroundColor(26, 26, 26, 255)

  love.graphics.setColor(26, 26, 26, 255)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

  love.graphics.setColor(108, 108, 108, 255)
  -- love.graphics.rectangle('fill', love.mouse.getX(), love.mouse.getY(), 100, 100)

  love.graphics.setColor(17, 17, 17, 255)
  -- love.graphics.print(bit.band(18, 2))
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print(obj.collisions)
  love.graphics.draw(sprites['digits'][9], love.mouse.getX(), love.mouse.getY(), 0, obj:dimensions())
  love.graphics.setColor(17, 17, 17, 255)
  love.graphics.line(0, love.graphics.getHeight() - 1, love.graphics.getWidth(), love.graphics.getHeight() - 1);
  love.graphics.line(0, 0, 0, love.graphics.getHeight() - 1);
  love.graphics.line(love.graphics.getWidth() - 1, 0, love.graphics.getWidth() - 1, love.graphics.getHeight());
  love.graphics.line(0, 0, love.graphics.getWidth() - 1, 0);
  love.graphics.setCanvas()

  -- PostFX Section --
  myShader:send("aberration", 0.1)
  myShader:send("distorsion", 1.4)
  love.graphics.setShader(myShader)
  love.graphics.draw(canvas)
  love.graphics.setShader()
end

-- On window resize --
function love.resize(w, h)
  canvas = love.graphics.newCanvas(w, h, "rgba8", 0)
end
