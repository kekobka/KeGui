if SERVER then
	return
end
---@include panel.lua
require("panel.lua")
local render = render
local PANEL = {}
accessorFunc(PANEL, "m_btitle", "Title", "Title")

local rad = math.rad
local sin = math.sin
local cos = math.cos

function PANEL:init()
	self.isdraggable = true

	self.minmaxButton = self:add("button")
	self.minmaxButton.font = KeGui.Fonts.main
	self.minmaxButton:setText("▼")
	self.minmaxButton.drawbg = false
	self.minmaxButton:setSize(24, 24)
	self.minmaxButton:setAlign(1)
	self.minmaxButton:setPos(0, 0)
	self._maximized = true
	self.minmaxButton.doClick = function()
		self:minimax()
	end

	self.sizeButton = self:add("button")
	self.sizeButton:alwaysFront(true)
	self.sizeButton:setSize(18, 18)
	self.sizeButton:setPos(self:getW() - 18, self:getW() - 18)
	local vertices = {}
	vertices[1] = {x = 0, y = 0}

	vertices[2] = {x = 0, y = 0}

	for i = 0, 12 do
		vertices[3 + i] = {x = 0, y = 0}
	end

	function self.sizeButton:paint(x, y, w, h)
		local style = KeGui.Style
		local x, y = x - 1, y - 1

		if self.used then
			render.setColor(style.ResizeGripActive)
		elseif self.hovered then
			render.setColor(style.ResizeGripHovered)
		else
			render.setColor(style.ResizeGrip)
		end
		local bordersize = style.WindowRounding
		if bordersize <= 0 then
			render.drawTriangle(x, y + h - 1, x + w - 1, y, x + w - 1, y + h - 1)
			return
		end

		render.setMaterial()

		vertices[1].x = x
		vertices[1].y = y + h

		vertices[2].x = x + w
		vertices[2].y = y

		for i = 0, 12 do
			local a = rad((i / 12) * -90 + 90)
			vertices[3 + i].x = x + w - bordersize + sin(a) * bordersize
			vertices[3 + i].y = y + h - bordersize + cos(a) * bordersize
		end
		render.drawPoly(vertices)

	end
	self.sizeButton.onMousePressed = function(p, x, y)
		self.sizeButton.used = true
		local px, py = p:getAbsolutePos()
		self.offsetx = px - x + p:getW()
		self.offsety = py - y + p:getH()
		p:mouseCapture(true)
	end
	self.sizeButton.onMouseReleased = function(p, x, y)
		self.sizeButton.used = false
		p:mouseCapture(false)
	end
	self.sizeButton.onMouseMoved = function(p, x, y)
		x, y = self:screenToLocal(x, y)
		local min = KeGui.Style.WindowMinSize
		self:setSize(math.max(x + self.offsetx, min.x), math.max(y + self.offsety, min.y))
	end
end

function PANEL:setSizable(b)
	self.m_bSizable = b
	self.sizeButton.visible = b
end

function PANEL:cursorIntersectHovered(x, y)
	local x, y = self:screenToLocal(x, y)

	return y < 24
end

function PANEL:setSize(w, h)
	self:setW(w)
	self:setH(h)
	self:invalidateLayout()
end

function PANEL:sizeToAllChildren(a, b)
	if self:isMinimized() then
		return
	end

	self.class.super.sizeToAllChildren(self, a, b)
	self:setSize(self:getW() + 4, self:getH() + 4)
end

function PANEL:performLayout(w, h)
	local pos = KeGui.Style.WindowMenuButtonPosition
	if pos == KeGuiDir_Left then
		self.minmaxButton:setPos(KeGui.Style.FramePadding.x / 2, 0)
	elseif pos == KeGuiDir_Right then
		self.minmaxButton:setPos(w - 24 - 4 - KeGui.Style.FramePadding.x / 2, 0)
	else
		self.minmaxButton:setPos(-100, -100)
	end

	self.sizeButton:setPos(w - 18, math.max(h - 18, 18))
end

function PANEL:minimax()
	if self._maximized then
		self:minimize()
	else
		self:maximize()
	end
end

function PANEL:isMinimized()
	return not self._maximized
end

function PANEL:minimize()
	self._maximized = false
	self._minimaxH = self:getH()
	
	self:setSize(self:getW(), 24)
	self.minmaxButton:setText("►")
	
	local address = self.address .. "minimax"
	self:toAllChild(function(child)
		if child == self.minmaxButton or child == self.closeButton then
			return
		end
		child[address] = child.visible
		child.visible = false
	end)
end
function PANEL:maximize()
	self._maximized = true

	local address = self.address .. "minimax"
	self:toAllChild(function(child)
		if child == self.minmaxButton or child == self.closeButton then
			return
		end
		child.visible = child[address]
	end)

	self:setSize(self:getW(), self._minimaxH)
	self._minimaxH = nil
	self.minmaxButton:setText("▼")
end

function PANEL:paint(x, y, w, h)
	local style = KeGui.Style

	local bsize = style.WindowBorderSize
	local round = style.WindowRounding
	self:paintBorder(x, y, w, h, round)

	render.setColor(style.WindowBg)
	render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, h - bsize * 2 - 1)

	if self:isMinimized() then
		render.setColor(style.TitleBgCollapsed)
	elseif self:isAbove() then
		render.setColor(style.TitleBgActive)
	else
		render.setColor(style.TitleBg)
	end
	render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, 24 - bsize * 2 - 1)

	render.setColor(style.Text)
	render.setFont(KeGui.Fonts.main)

	local align = style.WindowTitleAlign
	local tx, ty = render.getTextSize(self:getTitle())
	local mx = style.FramePadding.x

	render.drawSimpleText(x + 24 + align.x * (w - tx - 48 - mx / 2 - 4), y + 1 + align.y * (24 - ty), self:getTitle(), 0, 0)

end

function PANEL:onMousePressed(x, y, key, keyName)

	if self.isdraggable and key == MOUSE.MOUSE1 then
		local aX, aY = self:getAbsolutePos()
		self.used = true
		self._dragStartPos = {x - self:getX(), y - self:getY()}
		self:mouseCapture(true)
	end
end

function PANEL:onMouseReleased(x, y, key, keyName)
	if key == MOUSE.MOUSE1 then
		if self.isdraggable then
			self._dragStartPos = nil
			self:mouseCapture(false)
			self.used = false
		end
	end
end

function PANEL:onMouseMoved(x, y)
	if self._dragStartPos then
		local targetX, targetY = x - self._dragStartPos[1], y - self._dragStartPos[2]

		self:setPos(targetX, targetY)
		self:invalidateLayout()
	end
end

KeGui.register("Window", PANEL, "Panel")
