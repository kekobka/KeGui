---@include button.lua
require("button.lua")

local PANEL = {}

accessorFunc(PANEL, "m_bChecked", "Checked", false)

function PANEL:init()
	self:setText("Checkbox")
	self:setSize(96, 24)
end

function PANEL:paint(x, y, w, h)
	local style = KeGui.Style

	local bsize = style.FrameBorderSize
	local round = style.FrameRounding

	self:paintBorder(x, y, h, h, round)

	if self.used then
		render.setColor(style.FrameBgActive)
	elseif self.hovered then
		render.setColor(style.FrameBgHovered)
	else
		render.setColor(style.FrameBg)
	end

	render.drawRoundedBox(round, x + bsize, y + bsize, h - bsize * 2 - 1, h - bsize * 2 - 1)

	local x = x + h / 2
	local y = y + h / 2
	render.setFont(self.font)
	if self:getChecked() then
		-- render.setFont(KeGui.Fonts.icons)
		render.setColor(style.CheckMark)

		-- render.drawSimpleText(x, y, string.utf8char(0xE73E), 1, 1) -- "✓"
		render.drawSimpleText(x, y, "✓", 1, 1) -- "✓"
	end
	render.setColor(style.Text)
	render.drawSimpleText(x + h / 2 + 3, y, self:getText(), 0, 1)
end

function PANEL:onMousePressed(x, y, key, keyName)
	if (key == MOUSE.MOUSE1 or key == MOUSE.MOUSE2) then
		self.used = true
		self:listenRelease(true)
	end
end

function PANEL:toggle()
	self:setChecked(not self:getChecked())
end
function PANEL:sizeToContents()
	local w, h = self:getTextSize()
	self:setSize(w + 22 + 3, h + 4)
end

function PANEL:onMouseReleased(x, y, key, keyName)

	if (key == MOUSE.MOUSE1 or key == MOUSE.MOUSE2) and self.used then
		if self:cursorIntersect(x, y) then
			if key == MOUSE.MOUSE1 then
				self:toggle()
				self:doClick()
			elseif key == MOUSE.MOUSE2 then
				self:doRightClick()
			end
		end
		self.used = false
	end
end

KeGui.register("Checkbox", PANEL, "Label")
