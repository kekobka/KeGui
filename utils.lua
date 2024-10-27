function accessorFunc(tbl, varName, name, defaultValue)
	tbl[varName] = defaultValue
	tbl["get" .. name] = function(self)
		return self[varName]
	end
	tbl["set" .. name] = function(self, value)
		self[varName] = value
	end
end

EVENT = {THINK = 1, MOUSE_PRESSED = 2, MOUSE_RELEASED = 3, BUTTON_PRESSED = 4, BUTTON_RELEASED = 5, MOUSE_MOVED = 6, MOUSE_WHEELED = 7}
FILL = 1
LEFT = 2
RIGHT = 3
TOP = 4
BOTTOM = 5
if CLIENT then
	FONTS = {
		icons = render.createFont("Segoe MDL2 Assets", 18, 400, true, true, true, false, nil, true, 0),
		main = render.createFont("Roboto", 18, 500, true, nil, nil, nil, nil, true, nil),
		main20 = render.createFont("Roboto", 20, 500, true, nil, nil, nil, nil, true, nil),
	}
end

KeGuiDir_None = -1
KeGuiDir_Left = 0
KeGuiDir_Right = 2

function ImVec2(x, y)
	return Vector(x, y, 0)
end

function ImVec4(r, g, b, a)
	return Color(r * 255, g * 255, b * 255, a * 255)
end

local math_lerp = math.lerp
function ImLerp(from, to, t)
	local r = math_lerp(t, from.r, to.r)
	local g = math_lerp(t, from.g, to.g)
	local b = math_lerp(t, from.b, to.b)
	local a = math_lerp(t, from.a, to.a)
	return Color(r, g, b, a)
end

local table_getKeys = table.getKeys
local table_sort = table.sort
local next = next
function sortedPairs(pTable, Desc)
	local keys = table_getKeys(pTable)

	if Desc then
		table_sort(keys, function(a, b)
			return a > b
		end)
	else
		table_sort(keys, function(a, b)
			return a < b
		end)
	end

	local i, key
	return function()
		i, key = next(keys, i)
		return key, pTable[key]
	end
end

if not render then
	return
end
local cache = {}
local math_rad = math.rad
local sin = math.sin
local cos = math.cos
local poly = render.drawPoly
function render.drawArc(x, y, ang, p, rad, seg)
	seg = seg or 80
	ang = (-ang) + 180
	if not cache[seg] then
		local vertices = {}
		vertices[1] = {}
		for i = 0, seg do
			vertices[2 + i] = {}
		end
		cache[seg] = vertices
	end
	local vertices = cache[seg]
	vertices[1].x = x
	vertices[1].y = y
	for i = 0, seg do
		local a = math_rad(i / seg * (-p) + ang)
		vertices[2 + i].x = x + sin(a) * rad
		vertices[2 + i].y = y + cos(a) * rad
	end
	poly(vertices)
end

local color1 = Color(0, 0, 0, 1)
local render_drawArc = render.drawArc
local render_clearStencil = render.clearStencil
local render_setStencilEnable = render.setStencilEnable
local render_setStencilReferenceValue = render.setStencilReferenceValue
local render_setStencilWriteMask = render.setStencilWriteMask
local render_setStencilTestMask = render.setStencilTestMask
local render_setStencilPassOperation = render.setStencilPassOperation
local render_setColor = render.setColor
local render_drawRectFast = render.drawRectFast
local render_setStencilCompareFunction = render.setStencilCompareFunction
local render_drawRoundedBox = render.drawRoundedBox
local STENCIL_INCR = STENCIL.INCR
local STENCIL_GREATER = STENCIL.GREATER
local STENCIL_KEEP = STENCIL.KEEP

function render.drawRoundedBoxOutlined(r, x, y, w, h, t, clr)
	render_clearStencil()
	render_setStencilEnable(true)
	render_setStencilReferenceValue(1)
	render_setStencilWriteMask(1)
	render_setStencilTestMask(1)
	render_setStencilPassOperation(STENCIL_INCR)
	render_setColor(color1)
	render_drawRectFast(x + r + t, y + t, w - r * 2 - t * 2, h - t * 2)
	render_drawRectFast(x + t, y + r + t, w - t * 2, h - r * 2 - t * 2)
	render_drawArc(x + w - (r + t), y + (r + t), 0, 90, r, 12)
	render_drawArc(x + w - (r + t), y + h - (r + t), 90, 90, r, 12)
	render_drawArc(x + (r + t), y + h - (r + t), 180, 90, r, 12)
	render_drawArc(x + (r + t), y + (r + t), 270, 90, r, 12)
	render_setStencilCompareFunction(STENCIL_GREATER)
	render_setStencilPassOperation(STENCIL_KEEP)
	render_setColor(clr)
	render_drawRoundedBox(r, x, y, w, h)
	render_setStencilEnable(false)
end

local meshBegin = mesh.generate
local meshEnd = mesh.End
local meshPosition = mesh.writePosition
local meshColor = mesh.writeColor
local meshAdvanceVertex = mesh.advanceVertex

local mat_ignorez = material.load("color_ignorez")

function render.drawGradientLine(startX, startY, endX, endY, startColor, endColor)
	if endColor == nil then
		endColor = startColor
	end

	render.setMaterial(mat_ignorez)

	meshBegin(nil, 1, 1, function()
		meshColor(startColor.r, startColor.g, startColor.b, startColor.a)

		meshPosition(Vector(startX, startY, 0))

		meshAdvanceVertex()

		meshColor(endColor.r, endColor.g, endColor.b, endColor.a)

		meshPosition(Vector(endX, endY, 0))

		meshAdvanceVertex()
	end)

end
