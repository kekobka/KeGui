if SERVER then
	return
end
---@include label.lua
require("label.lua")
local PANEL = {}
local matrix = Matrix()
local matrix_a = Angle()
local matrix_v = Vector()

function PANEL:init()
	self.drawbg = true

	self:setAlignY(1)

	self:setText("Button")

	self:setSize(64, 24)
end

function PANEL:paint(x, y, w, h)
	local style = KeGui.Style

	if self.drawbg then
		local bsize = style.FrameBorderSize
		local round = style.FrameRounding

		self:paintBorder(x, y, w, h, round)

		if self.used then
			render.setColor(style.ButtonActive)
		elseif self.hovered then
			render.setColor(style.ButtonHovered)
		else
			render.setColor(style.Button)
		end
		render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, h - bsize * 2 - 1)

	end

	if self.disabled then
		render.setColor(style.TextDisabled)
	else
		render.setColor(style.Text)
	end

	x = x + (self.alignX == 1 and w / 2 or style.FramePadding.x)
	y = y + (self.alignY == 1 and h / 2 or 1)

	render.setFont(self.font)
	render.drawSimpleText(x, y, self.text, self.alignX, self.alignY)

end

function PANEL:setText(text)
	self.text = tostring(text)

	render.setFont(self.font)
	self._textWidth, self._textHeight = render.getTextSize(self.text)

	return self
end

KeGui.register("Button", PANEL, "Label")
