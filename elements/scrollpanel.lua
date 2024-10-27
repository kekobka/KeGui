if SERVER then
	return
end
---@include panel.lua
require("panel.lua")
local PANEL = {}
accessorFunc(PANEL, "used", "Used", false)

function PANEL:init()
	self:setWheelEnabled(true)
	self.lines = {}
	self.offset = 0
	self.maxh = 0
	self:setSize(250, 6 + 18 * 5)
	self.canvas = self.class.super.add(self, "panel")
	self.canvas.paint = function()
	end
	local w, h = self:getSize()
	self.canvas:setSize(w - KeGui.Style.ScrollbarSize, h)
end

function PANEL:add(name)
	local panel = self.canvas:add(name)
	table.insert(self.lines, panel)
	panel:setW(self:getW() - 3 - KeGui.Style.ScrollbarSize)
	panel:setPos(2, 2 + self.maxh)
	self.maxh = self.maxh + panel:getH()
	self.canvas:setH(self.maxh)
	return panel
end

function PANEL:paint(x, y, w, h)
	local style = KeGui.Style

	local bsize = style.ChildBorderSize
	local round = style.ChildRounding

	self:paintBorder(x, y, w, h, round)

	render.setColor(style.ChildBg)
	render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, h - bsize * 2 - 1)

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

	local off = self.offset / math.max(0, self.maxh - self:getH() + 4)

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
	self.offset = math.clamp(self.offset - delta * 10, 0, math.max(0, self.maxh - self:getH() + 4))
	self:applyOffset()
end
function PANEL:performLayout(width, height)
	self.canvas:setSize(width - KeGui.Style.ScrollbarSize, self.maxh)
end

function PANEL:onMouseMoved(x, y)
	x, y = self:screenToLocal(x, y)
	local w, h = self:getSize()

	y = math.clamp(y, 0, h) / h
	local s = self.maxh - h + 2
	self.offset = math.clamp(y * s, 0, math.max(0, s))
	self:applyOffset()

end

function PANEL:scrollIntersect(aX, aY, w, h)
	local x, y = KeGui.getCursor()

	if x >= aX and x < aX + w and y >= aY and y < aY + h then
		return true
	end

	return false
end
function PANEL:applyOffset()
	self.canvas:setY(-self.offset)
	for i, v in ipairs(self.lines) do
		if not v.visible and not v._scrolvis then
			goto c
		end
		if (v:getY() + v:getH()) - self.offset < 0 then
			v.visible = false
			v._scrolvis = true
		elseif v:getY() - self.offset > self:getH() then
			v.visible = false
			v._scrolvis = true
		else
			v.visible = true
		end
		::c::
	end
end

function PANEL:doClick()
end

function PANEL:doRightClick()
end

function PANEL:_onUse(bool, x, y, key, keyName)
end

function PANEL:isUsed()
	return self.used
end

function PANEL:onUse(bool)
end

KeGui.register("ScrollPanel", PANEL, "Panel")
