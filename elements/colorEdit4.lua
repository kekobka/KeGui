---@include Panel.lua
require("Panel.lua")
---@include sliderInput.lua
require("sliderInput.lua")
local min = math.min

local PANEL = {}

function PANEL:init()
	self.sliders = {}
	local RGBA = "RGBA"

	local clr = Color(255, 255, 255, 255)

	for i = 1, 4, 1 do
		local input = self:add("SliderInput")
		input:setPos((i - 1) * 58, 0)
		input:setSize(52, 24)
		input:setAlignX(1)
		input:setText(255)
		input:setMaxValue(255)
		input:setPlaceholder(255)
		input:setRound(true)
		input:setNumeric(true)
		input:setMaxInput(3)
		local bukva = string.sub(RGBA, i, i)
		self.sliders[bukva] = input
		function input:getText()
			return bukva .. ":" .. self.text
		end

		function input:onFinish(t)
			clr[bukva:lower()] = tonumber(t) or 255
		end
	end

	self.colorPanel = self:add("Panel")
	local colorPanel = self.colorPanel
	colorPanel:setPos(4 * 58, 0)
	colorPanel:setSize(24, 24)

	function colorPanel:paint(x, y, w, h)
		local style = KeGui.Style

		local bsize = style.FrameBorderSize
		local round = style.FrameRounding

		self:paintBorder(x, y, w, h, round)

		render.setColor(clr)
		render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, h - bsize * 2 - 1)
	end
	self:setSize(256, 24)
end

function PANEL:paint(x, y, w, h)
end

KeGui.register("ColorEdit4", PANEL, "Panel")
