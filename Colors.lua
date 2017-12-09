Colors = {}

local function add(t, color, ...)
    if not color then return t end
    for i = 1, #color do
        t[i] = (t[i] or 0) + color[i]
    end
    return add(t, ...)
end

local function multiply(t, color, ...)
    if not color then return t end
    for i = 1, #color do
        t[i] = math.floor((t[i] or 255) * color[i] / 255 + 0.5)
    end
    return multiply(t, ...)
end

function Colors.multiply(...) return multiply({}, ...) end
function Colors.add(...) return add({}, ...) end

return Colors
