
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
  plataforms = Sprites:init('data/Sprites/plataforms.png', 'data/Sprites/plataforms.json')

  -- Test variables --
  plataform = GameObject:init(plataforms['SandPlataform'], 1)
  plataform.rigidBody = Physics.STATIC
  Physics.addRect(plataform)

  char = Character:init(fontChars, 2)
  char:setVelocity(40, 50)
  char.posX = width / 2
  char.posY = height / 2
  char:setValue('!')
  char.color = {161, 201, 104, 255}
  char.bounciness = -0.3
  char.rigidBody = bit.bor(Physics.BORDERS, Physics.DYNAMIC)

  str = String:init(fontChars, 3, "Carácteres especiales¡!")
  str:setVelocity(100, 1.5)
  str.bounciness = -0.3
  str.rigidBody = bit.bor(Physics.BORDERS, Physics.DYNAMIC)
  Physics.addRect(str)

  number = Number:init(5, char)
  number:setVelocity(100, 1.5)
  number.scaleX = 2
  number.scaleY = 2
  number.rigidBody = bit.bor(Physics.BORDERS, Physics.DYNAMIC)
  Physics.addRect(number)
end

-- Update is called here
function love.update(deltaTime)
  Physics.rectCollisions(deltaTime)
  str:update(deltaTime)
  number.number = love.timer.getFPS()
  number:update(deltaTime)
  plataform:setPosition(love.mouse.getX() - plataform:getWidth(), love.mouse.getY() - plataform:getHeight());
  plataform:update(deltaTime)
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
  char:draw()
  str:draw()
  number:draw()
  plataform:draw()

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
