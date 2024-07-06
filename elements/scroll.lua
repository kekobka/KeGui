if SERVER then
	return
end
---@include panel.lua
require("panel.lua")
local PANEL = {}
accessorFunc(PANEL, "used", "Used", false)

function PANEL:init()
	self.lines = {}
	self.selected = nil
	self.offset = 0
	self:setSize(250, 6 + 18 * 5)
end

function PANEL:addLine(text)
	table.insert(self.lines, text)
end

function PANEL:removeLine(id)
	local r = table.remove(self.lines, id)
	if self.selected == r then
		self.selected = nil
	end

end
function PANEL:clear()
	self.lines = {}
	self.selected = nil
end

function PANEL:getLines()
	return self.lines
end

function PANEL:paint(x, y, w, h)
	local style = KeGui.Style

	local bsize = style.ChildBorderSize
	local round = style.ChildRounding

	self:paintBorder(x, y, w, h, round)

	render.setColor(style.ChildBg)
	render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, h - bsize * 2 - 1)

	render.setColor(style.Text)
	render.setFont(KeGui.Fonts.main)
	local lines = self.lines
	for i = 1, self:getMax(), 1 do
		local w = w - style.ScrollbarSize
		local line = lines[self.offset + i]
		if not line then
			break
		end
		if self.selected == line or self:itemIntersect(x + 6, y + (i - 1) * 20, w - 10, 20) then
			if self.used then
				render.setColor(style.HeaderActive)
			else
				render.setColor(style.HeaderHovered)
			end
			render.drawRectFast(x + 6, 5 + y + (i - 1) * 20, w - 12, 18)
		end
		render.setColor(style.Text)
		render.drawSimpleText(x + 6, 5 + y + (i - 1) * 20, line, 0, 0)
	end

	local bsize = style.ScrollbarSize
	local sround = style.ScrollbarRounding

	render.setColor(style.ScrollbarBg)
	render.drawRoundedBox(round, x + w - bsize - 2, y + 2, bsize - 1, h - 5)

	if self.knobused then
		render.setColor(style.ScrollbarGrabActive)
	elseif self:scrollIntersect(x + self:getW() - KeGui.Style.ScrollbarSize, y, KeGui.Style.ScrollbarSize, self:getH()) then
		render.setColor(style.ScrollbarGrabHovered)
	else
		render.setColor(style.ScrollbarGrab)
	end

	local off = self.offset / (#self.lines - self:getMax())

	render.drawRoundedBox(round, x + w - bsize - 1, y + 3 + off * (h - 25), bsize - 3, 18)

end

function PANEL:onMousePressed(x, y, key, keyName)

	if (key == MOUSE.MOUSE1 or key == MOUSE.MOUSE2) then
		self.used = true
		self:_onUse(true, x, y, key, keyName)
		self:onUse(true)
		self:listenRelease(true)
		local x, y = self:getAbsolutePos()
		if self:scrollIntersect(x + self:getW() - KeGui.Style.ScrollbarSize, y, KeGui.Style.ScrollbarSize, self:getH()) then
			self:mouseCapture(true)
			self.knobused = true
		end
	end
end

function PANEL:onMouseReleased(x, y, key, keyName)

	if (key == MOUSE.MOUSE1 or key == MOUSE.MOUSE2) and self.used then
		if self:cursorIntersect(x, y) then
			if key == MOUSE.MOUSE1 then
				self:doClick()
				local lines = self.lines
				for i = 1, self:getMax(), 1 do
					local line = lines[self.offset + i]
					if not line then
						break
					end
					local x, y = self:getAbsolutePos()
					if self:itemIntersect(x + 6, y + (i - 1) * 20, self:getW() - KeGui.Style.ScrollbarSize - 10, 20) then
						self.selected = line
						self:onSelect(self.offset + i, line)
						break
					end

				end
			elseif key == MOUSE.MOUSE2 then
				self:doRightClick()
			end
		end
		self.used = false
		self:_onUse(false, x, y, key, keyName)
		self:onUse(false)
		self:mouseCapture(false)
		self.knobused = false
	end
end

function PANEL:onMouseWheeled(x, y, delta)
	self.offset = math.clamp(self.offset - delta * 2, 0, math.max(#self.lines - self:getMax(), 0))
end

function PANEL:onMouseMoved(x, y)
	x, y = self:screenToLocal(x, y)
	local w, h = self:getSize()

	y = math.clamp(y, 0, h) / h
	self.offset = math.clamp(math.round(y * (#self.lines - self:getMax())), 0, math.max(#self.lines - self:getMax(), 0))

end

function PANEL:itemIntersect(aX, aY, w, h)
	local x, y = KeGui.getCursor()
	y = y - 5
	if x >= aX and x < aX + w and y >= aY and y < aY + h then
		return true
	end

	return false
end

function PANEL:scrollIntersect(aX, aY, w, h)
	local x, y = KeGui.getCursor()

	if x >= aX and x < aX + w and y >= aY and y < aY + h then
		return true
	end

	return false
end

function PANEL:getMax()
	return math.floor((self:getH() - 10) / 20)
end

function PANEL:setMax(n)
	self:setH(10 + n * 20)
end

function PANEL:doClick()
end

function PANEL:doRightClick()
end
function PANEL:onSelect(id, line)
end

function PANEL:_onUse(bool, x, y, key, keyName)
end

function PANEL:isUsed()
	return self.used
end

function PANEL:onUse(bool)
end

KeGui.register("Scroll", PANEL, "Panel")
