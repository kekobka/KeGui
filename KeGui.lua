if KeGui then
	return
end
---@include ./utils.lua
require("./utils.lua")

local ELEMENTS = {}

---@class KeGui
KeGui = class("KeGui")

KeGui.EVENT = {
	MOUSE_PRESSED = "KeGui.EVENT.MOUSE_PRESSED",
	MOUSE_RELEASED = "KeGui.EVENT.MOUSE_RELEASED",
	MOUSE_MOVED = "KeGui.EVENT.MOUSE_MOVED",
	MOUSE_WHEELED = "KeGui.EVENT.MOUSE_WHEELED",
	HOVERED = "KeGui.EVENT.HOVERED",

	---TODO
	-- BUTTON_PRESSED = "KeGui.EVENT.BUTTON_PRESSED",
	-- BUTTON_RELEASED = "KeGui.EVENT.BUTTON_RELEASED",
}
do
	---@includedir styles
	local styles = requiredir("styles")
	KeGui.Styles = {}
	local __rawStyles = {}
	local __rawStylesNormalized = {}
	function KeGui.setStyle(name)
		name = KeGui.styleNameNormalize(name) or name
		local style = KeGui.Styles[name]
		if not style then
			return throw(name .. " is not style")
		end
		KeGui.Style = style()
		hook.run("KeGui.STYLE_CHANGED")
	end

	function KeGui.styleNameFix(name)
		name = __rawStyles[name]
		local ret = name[1]:upper()
		for i = 2, #name, 1 do
			if name[i]:upper() == name[i] then
				ret = ret .. " " .. name[i]
			else
				ret = ret .. name[i]
			end
		end
		return ret
	end

	function KeGui.styleNameNormalize(name)
		return __rawStylesNormalized[name]
	end

	for path, data in pairs(styles) do
		local name = string.match(path, "/(%w+).lua$")
		local namelower = string.lower(name)
		KeGui.Styles[namelower] = data
		__rawStyles[namelower] = name
		__rawStylesNormalized[KeGui.styleNameFix(namelower)] = namelower
	end
end

KeGui.setStyle("classic")

local string_lower = string.lower
local string_match = string.match
local input_getCursorPos = input and input.getCursorPos

function KeGui.static.new(name, parent)
	if not name then
		return
	end
	local el = ELEMENTS[string_lower(name)]
	assert(istable(el), name .. " is not element")
	local el = el()

	if parent then
		parent:addChild(el)
	else
		KeGui.root:addChild(el)
	end

	return el
end

function KeGui.static.register(name, mtable, root)
	local super
	if root then
		super = ELEMENTS[string_lower(root)]

		assert(istable(super), root .. " is not element")
	end
	local cls = KeGui.class(name, super)
	if mtable.init then
		local old = cls.initialize
		function cls.initialize(...)
			old(...)
			mtable.init(...)
		end
	end
	ELEMENTS[string_lower(name)] = table.merge(cls, mtable)
end

function KeGui.static.getCursor()
	return input_getCursorPos()
end

function KeGui.static.class(name, super)
	return class("KeGui." .. name, super)
end

function KeGui.static.hasElement(name)
	return istable(ELEMENTS[string_lower(name)])
end

local ANIMATIONWORKERS = {}
hook.add("Think", "ANIMATIONWORKERS", function()
	for Key, work in ipairs(ANIMATIONWORKERS) do
		work(Key)
	end
end)

function KeGui.static.newAnimation(speed, delay, callback, finish)
	timer.simple(delay, function()
		local progress = 0
		table.insert(ANIMATIONWORKERS, function(Key)
			progress = progress + timer.frametime() * speed
			callback(progress)
			if progress >= 1 then
				table.remove(ANIMATIONWORKERS, Key)
				if finish then
					finish()
				end
			end
		end)
	end)
end

---@includedir ./elements
requiredir("./elements")

if SERVER then
	return
end

KeGui.static.openkey = "g"
KeGui.static.root = ELEMENTS.root()

KeGui.static.preRender = function()
end
KeGui.static.postRender = function()
end

local root = KeGui.root
root.visible = false
local _resx, _resy = render.getGameResolution()
root:setSize(_resx, _resy)
KeGui.Fonts = FONTS
KeGui.static.setVisible = function(bool)
	root.visible = bool
end
local function render()
	if not root.visible then
		return
	end
	root:_postEventToAllReverseRender(0, 0, _resx, _resy)
end

local function paint()
	KeGui.preRender()
	render()
	KeGui.postRender()
end
hook.add("KeGui.STYLE_CHANGED", "KeGui.STYLE_CHANGED", function()
	root:invalidateLayoutRecursive()
end)
hook.add("PostDrawHud", "KeGui.PostDrawHud." .. KeGui.root.address, paint)
local _lastMouseX, _lastMouseY = 0, 0
local huge = math.huge
local hook_run = hook.run
hook.add("Think", "KeGui.Think." .. KeGui.root.address, function()
	input.enableCursor(root.visible)
	local x, y = KeGui.getCursor()

	if x and y and (x ~= _lastMouseX or y ~= _lastMouseY) then
		_lastMouseX = x
		_lastMouseY = y
		hook_run("KeGui.MOUSE_MOVED", x, y)
		root:_postEvent(EVENT.MOUSE_MOVED, x, y)
		hook_run("KeGui.POSTMOUSE_MOVED", x, y)
	end

	root:_postEvent(EVENT.THINK)
end)

hook.add("InputPressed", "VUI.InputPressed." .. KeGui.root.address, function(key)
	if input.getKeyName(key) == KeGui.openkey then
		input.enableCursor(not input.getCursorVisible())
		KeGui.setVisible(input.getCursorVisible())
	end

	local keyName = input.getKeyName(key)
	local x, y = KeGui.getCursor()

	if key >= 107 and key <= 111 and root.visible then
		hook_run("KeGui.MOUSE_PRESSED", x, y, key, keyName)
		root:_postEvent(EVENT.MOUSE_PRESSED, x, y, key, keyName)
		hook_run("KeGui.MOUSE_POSTPRESSED", x, y, key, keyName)
		---TODO
		-- else
		-- 	hook_run("KeGui.BUTTON_PRESSED", x, y, key, keyName)
		-- 	root:_postEvent(EVENT.BUTTON_PRESSED, x, y, key, keyName)
	end
end)

hook.add("mouseWheeled", "KeGui.InputReleased." .. KeGui.root.address, function(delta)
	local x, y = KeGui.getCursor()
	hook_run("KeGui.POSTMOUSE_WHEELED", x, y, delta)
	root:_postEvent(EVENT.MOUSE_WHEELED, x, y, delta)
	hook_run("KeGui.POSTMOUSE_WHEELED", x, y, delta)
end)

hook.add("InputReleased", "KeGui.InputReleased." .. KeGui.root.address, function(key)
	if not hasPermission("input") or not input.getCursorVisible() then
		return
	end
	local keyName = input.getKeyName(key)
	local x, y = KeGui.getCursor()

	if key >= 107 and key <= 111 and root.visible then
		hook_run("KeGui.MOUSE_RELEASED", x, y, key, keyName)
		root:_postEvent(EVENT.MOUSE_RELEASED, x, y, key, keyName)
		hook_run("KeGui.MOUSE_POSTRELEASED", x, y, key, keyName)
		---TODO
		-- else
		-- 	hook_run("KeGui.BUTTON_RELEASED", x, y, key, keyName)
		-- 	root:_postEvent(EVENT.BUTTON_RELEASED, x, y, key, keyName)
	end
end)
