---@include panel.lua
require("panel.lua")
local PANEL = {}
accessorFunc(PANEL, "used", "Used", false)

function PANEL:init()
	self:setSize(256, 24)
	self.size = 0
	self.samples = {}
end

local remap = math.remap
local drawLine = render and render.drawLine

function PANEL:paint(x, y, w, h)
	local style = KeGui.Style

	local bsize = style.FrameBorderSize
	local round = style.FrameRounding

	self:paintBorder(x, y, w, h, round)

	if self.used then
		render.setColor(style.FrameBgActive)
	elseif self.hovered then
		render.setColor(style.FrameBgHovered)
	else
		render.setColor(style.FrameBg)
	end
	render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, h - bsize * 2 - 1)

	local size = self.size
	local samples = self.samples
	if size < 2 then
		return
	end
	local off = 2
	local x1 = remap(1, 1, size, x + off, x + w - off)
	local x2 = remap(2, 1, size, x + off, x + w - off)
	local y2 = remap(samples[1], -1, 1, y + h - off, y + off)
	local y1 = remap(samples[2], -1, 1, y + h - off, y + off)
	render.setColor(style.PlotLines)

	for i = 3, size, 1 do
		x2 = remap(i, 1, size, x + off, x + w - off)
		y2 = remap(samples[i], -1, 1, y + h - off, y + off)

		drawLine(x1, y1, x2, y2)
		x1 = x2
		y1 = y2
	end

end

function PANEL:setLines(samples, size)

	self.size = size or #samples
	self.samples = samples or {}
end
KeGui.register("PlotLines", PANEL, "Panel")
