if SERVER then
	return
end
---@include Panel.lua
require("Panel.lua")
---@include sliderInput.lua
require("sliderInput.lua")
local min = math.min

local PANEL = {}

function PANEL:init()
	self.sliders = {}
	local xyz = "xyz"

	self.val = Vector(0, 0, 0)
	self.inputs = {}
	for i = 1, 3 do
		local input = self:add("SliderInput")
		self.inputs[i] = input
		input:setPos((i - 1) * 58, 0)
		input:setSize(52, 24)
		input:setAlignX(1)
		input:setPlaceholder(255)
		input:setNumeric(true)
		local bukva = string.sub(xyz, i, i)
		input.bukva = bukva
		self.sliders[bukva] = input
		function input:getText()
			return bukva .. ":" .. self.text
		end

		function input.onFinish(_, t)
			self.val[bukva:lower()] = tonumber(t) or 0
			self:onChanged(self.val)
		end
	end

	self:setSize(256, 24)
end

function PANEL:setValue(val)
	for i = 1, 3 do
		self.inputs[i]:setText(math.round(val[self.inputs[i].bukva:lower()]))
		self.val = val
	end
end

function PANEL:paint(x, y, w, h)
end

function PANEL:onChanged(val)
end

KeGui.register("Vector3Edit", PANEL, "Panel")
