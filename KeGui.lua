if KeGui then
	return
end
if SERVER then
	KeGui = {}
end
if player() ~= owner() then
	KeGui = {}
	return
end
enableHud(player(), true)
---@include ./utils.lua
require("./utils.lua")

---@include libs/task.txt
require("libs/task.txt")

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
	--- @includedir styles
	-- local styles = requiredir("styles")
	---@include styles/classic.lua
	KeGui.Styles = {}
	KeGui.Styles.classic = require("styles/classic.lua")
	KeGui.static.StyleName = "classic"
	KeGui.static.registerStylesFromRepo = async * function()
		local data = json.decode(fetch("https://api.github.com/repos/kekobka/KeGui/contents/styles"):await().body)
		for k, style in ipairs(data) do
			local name = string.match(style.name, "(%w+).lua$")
			if notyKeGui.Styles[name] then
				local str = fetch(style.download_url):await().body
				KeGui.Styles[name] = loadstring(str)()
			end
		end
	end

	KeGui.static.registerStyleFromRepo = async * function(name)
		if KeGui.Styles[name] then
			return
		end
		local request = fetch("https://raw.githubusercontent.com/kekobka/KeGui/main/styles/" .. name .. ".lua"):await()
		if request.code ~= 200 then
			return throw(name .. " is not a style")
		end
		KeGui.Styles[name] = loadstring(request.body)()
	end

	function KeGui.static.registerStyle(name, style)
		KeGui.Styles[name] = style
	end

	KeGui.static.setStyleFromRepo = async * function(name)
		name = string.trim(name)
		KeGui.static.registerStyleFromRepo(name):await()
		KeGui.setStyle(name)
	end

	function KeGui.setStyle(name, hidden)

		local style = KeGui.Styles[name]
		if not style then
			return throw(name .. " is not style")
		end
		KeGui.Style = style()
		KeGui.static.StyleName = name
		hook.run("KeGui.PRE_STYLE_CHANGED")
		hook.run("KeGui.STYLE_CHANGED")
		hook.run("KeGui.POST_STYLE_CHANGED")
		if not hidden then
			KeGui.hint("Set style: " .. name)
		end
	end
	function KeGui.hint(txt)
		if CLIENT and hasPermission("notification") then
			notification.addLegacy("[KeGui] " .. txt, NOTIFY.HINT, 3)
		end
	end
end

KeGui.setStyle("classic", true)

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
function KeGui.static.Clear()
	local _oldroot = root
	root = ELEMENTS.root()
	KeGui.static.root = root
	root.visible = _oldroot.visible
	_resx, _resy = render.getGameResolution()
	root:setSize(_resx, _resy)
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

hook.add("PlayerChat", "KeGui.Secret.Style" .. KeGui.root.address, function(ply, text)
	if ply ~= owner() then
		return
	end
	if string.sub(text, 1, 7) == "!kstyle" then
		KeGui.setStyleFromRepo(string.sub(text, 8))
	end
	if string.sub(text, 1, 7) == "!kclear" then
		KeGui.Clear()
	end
end)

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
