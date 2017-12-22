
-- Needed for bitwise operations --
local bit = require("bit")

Physics = {
  -- Rect Collisions --
  CTOP = 1,
  CBOTTOM = 2,
  CLEFT = 4,
  CRIGHT = 8,
  CABSCISSA = bit.bor(1, 2),
  CORDINATE = bit.bor(4, 8),

  -- RigidBody States --
  NONE = 0,
  BORDERS = 1,
  STATIC = 2,
  DYNAMIC = 4,

  gravity = 96.17038,

  rectColliders = {},
  collisionsState = {}
}

function Physics.addRect(element)
  Physics.rectColliders[element.id] = element;
end
function Physics.removeRect(element)
  Physics.rectColliders[element.id] = nil;
end


local function alreadyColliding(one, two)
  for i = 1, #Physics.collisionsState do
    if Physics.collisionsState[i][1] == one.id and
       Physics.collisionsState[i][2] == two.id then
        return true
    end
    if Physics.collisionsState[i][1] == two.id and
       Physics.collisionsState[i][2] == one.id then
        return true
    end
  end
  return false
end

local function removeCollision(one, two)
  for i = 1, #Physics.collisionsState do
    if Physics.collisionsState[i][1] == one.id and
       Physics.collisionsState[i][2] == two.id then
         table.remove(Physics.collisionsState, i)
         return true
    end
    if Physics.collisionsState[i][1] == two.id and
       Physics.collisionsState[i][2] == one.id then
         table.remove(Physics.collisionsState, i)
         return true
    end
  end
  return false
end

local function addCollision(one, two)
  if alreadyColliding(one, two) == true then return end
  table.insert(Physics.collisionsState, {one.id, two.id})
end

function Physics.rectCollisions(deltaTime)
  -- Clear Collisions --
  local rects = {} -- For optimization and uknown errors i make a sorted table
  for key,_ in pairs(Physics.rectColliders) do
    Physics.rectColliders[key].collisions = 0
    table.insert(rects, key)
  end

  if #rects == 0 then return 0 end

  local w, h, ow, oh, dx, dy -- Variables for detecting the collision
  local actual, other
  local collisions = 0

  for i = 1, #rects do
    actual = Physics.rectColliders[rects[i]]
  if actual.rigidBody ~= Physics.NONE then

    w = actual:getWidth()
    h = actual:getHeight()
    collisions = 0

    if bit.band(actual.rigidBody, Physics.BORDERS) > 0 then
      -- Border Collisions --
      if actual.posX < 0                             then collisions = bit.bor(collisions, Physics.CLEFT) end
      if actual.posX + w > love.graphics.getWidth()  then collisions = bit.bor(collisions, Physics.CRIGHT) end
      if actual.posY < 0                             then collisions = bit.bor(collisions, Physics.CTOP) end
      if actual.posY + h > love.graphics.getHeight() then collisions = bit.bor(collisions, Physics.CBOTTOM) end

      -- Clamp Position (prevents multiple collisions) --
      if bit.band(actual.rigidBody, Physics.DYNAMIC) > 0 then
        actual.posX = actual.posX + (actual.posX + w >= love.graphics.getWidth() and -actual.posX - w + love.graphics.getWidth() or
        actual.posX <= 0 and -actual.posX or 0)
        actual.posY = actual.posY + (actual.posY + h >= love.graphics.getHeight() and -actual.posY - h + love.graphics.getHeight() or
        actual.posY <= 0 and -actual.posY or 0)
      end

      if collisions > 0 then
        actual.collisions = bit.bor(actual.collisions, collisions)
        actual:onCollisionEnter(nil, collisions, deltaTime)
        -- actual:onCollisionExit(nil, collisions)
      end
    end

    -- Collisions with other rectangles using https://en.wikipedia.org/wiki/Minkowski_addition --
    for j = i + 1, #rects do
      other = Physics.rectColliders[rects[j]]

    if other.rigidBody ~= Physics.NONE then

      ow = (w + other:getWidth() ) * 0.5;
      oh = (h + other:getHeight()) * 0.5;
      dx = (actual.posX + w * 0.5) - (other.posX + other:getWidth()  * 0.5);
      dy = (actual.posY + h * 0.5) - (other.posY + other:getHeight() * 0.5);

      --[[ fill(0x6677CC88);
      rectMode(CENTER);
      rect(dx + width * 0.5, dy + height * 0.5, ow * 2, oh * 2);
      rectMode(CORNER); ]]--

      if math.abs(dx) <= ow and math.abs(dy) <= oh then -- Collision! --
        ow = ow * dy;
        oh = oh * dx;

        if oh > ow then
          if oh > -ow then -- Collision on the right --
            other.collisions  = bit.bor(other.collisions,  Physics.CRIGHT)
            actual.collisions = bit.bor(actual.collisions, Physics.CLEFT)
          else               -- at the top --
            other.collisions  = bit.bor(other.collisions,  Physics.CTOP)
            actual.collisions = bit.bor(actual.collisions, Physics.CBOTTOM)
          end
        elseif oh > -ow then -- at the bottom --
          other.collisions  = bit.bor(other.collisions,  Physics.CBOTTOM)
          actual.collisions = bit.bor(actual.collisions, Physics.CTOP)
        else
          other.collisions  = bit.bor(other.collisions,  Physics.CLEFT)
          actual.collisions = bit.bor(actual.collisions, Physics.CRIGHT)
        end

        if alreadyColliding(actual, other) == true then
          actual:onCollisionStay(other, actual.collisions, deltaTime)
          other:onCollisionStay(actual, other.collisions, deltaTime)
        else
          addCollision(actual, other)
          actual:onCollisionEnter(other, actual.collisions, deltaTime)
          other:onCollisionEnter(actual, other.collisions, deltaTime)
        end

      else
        if removeCollision(actual, other) == true then
          actual:onCollisionExit(other, actual.collisions, deltaTime)
          other:onCollisionExit(actual, other.collisions, deltaTime)
        end
      end
    end -- Continue
    end
  end -- Continue
  end
  return actual.collisions
end

return Physics
