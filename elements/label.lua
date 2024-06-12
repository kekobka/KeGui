---@include panel.lua
require("panel.lua")
local render = render
local PANEL = {}
accessorFunc(PANEL, "used", "Used", false)
function PANEL:init()
	self.font = KeGui.Fonts.main

	self._textWidth, self._textHeight = 0, 0
	self:setText("Text")
end
function PANEL:paint(x, y, w, h)
	local style = KeGui.Style
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

function PANEL:setRotate(v)
	self.m_bRotate = v
end

function PANEL:onMousePressed(x, y, key, keyName)

	if (key == MOUSE.MOUSE1 or key == MOUSE.MOUSE2) then
		self.used = true
		self:_onUse(true, x, y, key, keyName)
		self:onUse(true)
		self:listenRelease(true)
	end
end

function PANEL:setText(text)
	self.text = tostring(text)

	render.setFont(self.font)
	self._textWidth, self._textHeight = render.getTextSize(self.text)

	self:sizeToContents()
	return self
end
function PANEL:getText()
	return self.text
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
	end
end

function PANEL:sizeToContents()
	self:setSize(self:getTextSize())
end

function PANEL:getTextSize()
	return self._textWidth, self._textHeight
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

function PANEL:setAlign(x, y)
	self.alignX = x
	self.alignY = y or x
end

function PANEL:setAlignX(X)
	self.alignX = X
end

function PANEL:setAlignY(Y)
	self.alignY = Y
end

KeGui.register("Label", PANEL, "Panel")
