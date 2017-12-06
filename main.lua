require "SpritesData"
require "Number"

-- Load Sprite Library --
local Sprite = require("Sprite")
-- Needed for bitwise operations --
local bit = require("bit")

function love.load()
  -- Default Values --
  love.window.setMode(1000, 800, { resizable=true, vsync=false, minwidth=400, minheight=400, fullscreentype='exclusive' })
  love.window.setTitle("One <Button> Game")

  love.graphics.setDefaultFilter('nearest', 'nearest', 0)
  love.graphics.setLineWidth(2)
  love.mouse.setVisible(false)

  width = love.graphics.getWidth()
  height = love.graphics.getHeight()

  -- Game canvas initializer --
  canvas = love.graphics.newCanvas(width, height, "rgba8", 0)
  love.graphics.setCanvas(canvas)
  love.graphics.setBlendMode('alpha', 'alphamultiply')

  -- PostFX shaders --
  crtShader = love.graphics.newShader("CRT.frag")

  -- Sprite variables --
  sprites = Sprite:init(SpritesData)

  -- Test variables --
  obj = Character:init(sprites.characters, 2.4 * 2, 2)
  obj:setVelocity(10, 5)
  obj.color = {161, 201, 104, 255}

  number = Number:init(10, obj, sprites.characters['-'])
  number.number = -10000
  number.scale = 10
end

-- Update is called here
function love.update(deltaTime)
  obj:addDigit(0.001)
  obj:update(deltaTime)
  number.number = number.number + 1
  number:setPosition(love.mouse.getX(), love.mouse.getY());
  number:update(deltaTime)
end

-- Draw all you need here.
function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  love.graphics.setBackgroundColor(35, 35, 35, 255)

  love.graphics.setColor(35, 35, 35, 255)
  love.graphics.rectangle('fill', 0, 0, width, height)

  love.graphics.setColor(29, 29, 29, 255)
  -- love.graphics.rectangle('fill', love.mouse.getX(), love.mouse.getY(), 100, 100)
  -- love.graphics.print(bit.band(18, 2))
  love.graphics.setColor(194, 188, 163, 255)
  love.graphics.print(obj.collisions)
  number:draw()
  obj:draw()

  -- PostFX Section --
  -- TV Frame --
  love.graphics.setColor(29, 29, 29, 255)
  love.graphics.line(0, height - 1, width, height - 1);
  love.graphics.line(0, 0, 0, height - 1);
  love.graphics.line(width - 1, 0, width - 1, height);
  love.graphics.line(0, 0, width - 1, 0);
  love.graphics.setCanvas()

  crtShader:send("aberration", 0.1)
  crtShader:send("distorsion", 1.4)
  love.graphics.setShader(crtShader)
  love.graphics.draw(canvas)
  love.graphics.setShader()
end

-- On window resize --
function love.resize(w, h)
  width = w
  height = h
  canvas = love.graphics.newCanvas(w, h, "rgba8", 0)
end
