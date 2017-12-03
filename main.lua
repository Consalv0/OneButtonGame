-- Load some default values for our rectangle.
function love.load()
  love.window.setMode(800, 600, {resizable=true, vsync=false, minwidth=400, minheight=400})
  love.window.setTitle("One Button Game")

  love.graphics.setDefaultFilter('nearest', 'nearest', 0)
  love.graphics.setLineWidth(2)

  canvas = love.graphics.newCanvas(800, 600, "rgba8", 0)
  love.graphics.setCanvas(canvas)
  love.graphics.setDefaultFilter('nearest', 'nearest', 0)
  love.graphics.setBlendMode('alpha', 'alphamultiply')

  myShader = love.graphics.newShader("CRT.frag")
end

-- Update is called
function love.update(deltaTime)

end

-- Draw a coloured rectangle.
function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  -- love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setBackgroundColor(26, 26, 26, 255)

  love.graphics.setColor(26, 26, 26, 255)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.setColor(108, 108, 108, 255)
  love.graphics.rectangle('fill', love.mouse.getX(), love.mouse.getY(), 100, 100)
  love.graphics.setColor(17, 17, 17, 255)
  love.graphics.print(love.timer.getFPS(), 0, 0)
  love.graphics.line(0, love.graphics.getHeight() - 1, love.graphics.getWidth(), love.graphics.getHeight() - 1);
  love.graphics.line(0, 0, 0, love.graphics.getHeight() - 1);
  love.graphics.line(love.graphics.getWidth() - 1, 0, love.graphics.getWidth() - 1, love.graphics.getHeight());
  love.graphics.line(0, 0, love.graphics.getWidth() - 1, 0);
  love.graphics.setCanvas()
  myShader:send("aberration", love.mouse.getX() / love.graphics.getWidth())
  myShader:send("barrelD", 1 + love.mouse.getY() / love.graphics.getHeight() / 2)
  love.graphics.setShader(myShader)
  love.graphics.draw(canvas)
  love.graphics.setShader()
end
