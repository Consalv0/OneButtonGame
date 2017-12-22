
require "Number"
require "Character"
require "String"

-- Physiscs Sytem --
local Physics = require("Physics")
-- Load Colors --
local Colors = require("Colors")
-- Load Sprite Library --
local Sprites = require("Sprites")
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
  crtShader = love.graphics.newShader("data/Shaders/CRT.frag")

  -- Sprite variables --
  fontChars = Sprites:init('data/Font/font.png', 'data/Font/font.json')


  -- Test variables --
  objects = {}
  for i = 1, 100 do
    table.insert(objects, GameObject:init(fontChars['*'], (i + 15) / 15))
    objects[i].posX = i
    objects[i].posY = i
    objects[i].bounciness = -0.3
    objects[i].rigidBody = bit.bor(Physics.BORDERS, Physics.DYNAMIC)
    Physics.addRect(objects[i])
  end

  char = Character:init(fontChars, 5)
  char:setVelocity(40, 50)
  char.posX = width / 2
  char.posY = height / 2
  char:setValue('I')
  char.color = {161, 201, 104, 255}
  char.bounciness = -0.3
  char.rigidBody = bit.bor(Physics.BORDERS, Physics.DYNAMIC)
  Physics.addRect(char)

  str = String:init(fontChars, 4, 'I have no money')
  str:setVelocity(1, 1.5)
  str.rigidBody = bit.bor(Physics.BORDERS, Physics.DYNAMIC)
  Physics.addRect(str)

  number = Number:init(5, char)
  number.scaleX = 5
  number.scaleY = 5
  number.rigidBody = Physics.STATIC
  Physics.addRect(number)
end

-- Update is called here
function love.update(deltaTime)
  Physics.rectCollisions(deltaTime)
  str:update(deltaTime)
  char:update(deltaTime)
  number.number = love.timer.getFPS()
  number:setPosition(love.mouse.getX() - number:getWidth() / 2, love.mouse.getY() - number:getHeight() / 2);
  number:update(deltaTime)
  for i = 1, 100 do
    objects[i]:update(deltaTime)
  end
end

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

  --love.graphics.print(char.id)
  for i = 1, 100 do
    objects[i]:draw()
  end
  str:draw()
  char:draw()
  number:draw()

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
