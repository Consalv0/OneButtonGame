require "SpritesData"
require "Number"

-- Physiscs Sytem --
local Physics = require("Physics")
-- Load Colors --
local Colors = require("Colors")
-- Load Sprite Library --
local Sprite = require("Sprite")
-- Needed for bitwise operations --
local bit = require("bit")

function love.load()
  -- Default Values --
  love.window.setMode(9 * 50, 16 * 50, { resizable=true, vsync=false, minwidth=400, minheight=400, fullscreentype='exclusive' })
  love.window.setTitle("One <Button> Game")

  love.graphics.setDefaultFilter('nearest', 'nearest', 0)
  love.graphics.setLineWidth(2)
  -- love.mouse.setVisible(false)

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
  digit = Character:init(sprites.characters, 4, 2)
  digit:setVelocity(40, 50)
  digit.posX = width / 2
  digit.posY = height / 2
  digit.color = {161, 201, 104, 255}
  digit.rigidBody = bit.bor(Physics.BORDERS, Physics.DYNAMIC)
  Physics.addRect(digit)

  number = Number:init(5, digit, sprites.characters['-'])
  number.scale = 4
  number.rigidBody = Physics.STATIC
  Physics.addRect(number)
  Physics.removeRect(digit)
  Physics.addRect(digit)
end

-- Update is called here
function love.update(deltaTime)
  Physics:rectCollisions(deltaTime)
  digit:update(deltaTime)
  number.number = love.timer.getFPS()
  number:setPosition(love.mouse.getX() - number:getWidth() / 2, love.mouse.getY() - number:getHeight() / 2);
  number:update(deltaTime)
end

-- Draw all you need here.
function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  love.graphics.setBackgroundColor(45, 45, 42, 255)
  love.graphics.setColor({45, 45, 42, 255})
  love.graphics.rectangle('fill', 0, 0, width, height)

  love.graphics.setColor(29, 29, 26, 255)
  -- love.graphics.rectangle('fill', love.mouse.getX(), love.mouse.getY(), 100, 100)
  -- love.graphics.print(bit.band(18, 2))
  love.graphics.setColor(194, 188, 163, 255)
  love.graphics.print(number.id)
  number:draw()
  digit:draw()

  -- PostFX Section --
  -- TV Frame --
  love.graphics.setColor(29, 29, 26, 255)
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
