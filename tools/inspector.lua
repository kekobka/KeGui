Inspector = {}
InspectorValues = {}
InspectorTypes = {}
---@include ../kegui.lua
require("../kegui.lua")
local window
if CLIENT then
	window = KeGui.new("Window")
	window:setSize(1024, 1024)
	window:center()
end
local yPos = 24
InspectorTypes.Vector = {

	set = function(a, b)
		a.x = b.x
		a.y = b.y
		a.z = b.z
	end,
	widget = function(obj, setFunc)
		local panel = window:add("Vector3Edit")
		panel:setPos(4, yPos)
		yPos = yPos + panel:getH() + 2
		function panel:onChanged(val)
			setFunc(obj, val)
		end
		return {
			update = function(v)
				panel:setValue(v)
			end,
		}
	end,
}
local IValues = {}
InspectorNew = function(obj)

	local cls = obj.__class
	IValues[obj] = {}
	for k, v in pairs(Inspector[cls.__name]) do
		IValues[obj][k] = InspectorTypes[v]
		local updateFunc
		if CLIENT then
			local widget = InspectorTypes[v].widget(obj, obj["set_" .. k])
			updateFunc = widget.update
		end
		local oldSet = obj["set_" .. k]
		obj["set_" .. k] = function(a, b)
			oldSet(a, b)
			if CLIENT then
				updateFunc(obj["get_" .. k](obj))
			end
			return v
		end

	end
end
if SERVER then
	return
end

local x, y = render.getResolution()

