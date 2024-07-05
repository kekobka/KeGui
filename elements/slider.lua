if SERVER then
	return
end
---@include panel.lua
require("panel.lua")
local PANEL = {}

accessorFunc(PANEL, "m_bValue", "Value", 0.5)
accessorFunc(PANEL, "m_bVertical", "Vertical", false)

accessorFunc(PANEL, "m_fSlideX", "SlideX", 0)
accessorFunc(PANEL, "m_fSlideY", "SlideY", 0)

accessorFunc(PANEL, "m_iLockX", "LockX")
accessorFunc(PANEL, "m_iLockY", "LockY")

function PANEL:init()
	self:setSize(256, 24)
	self.m_iLockY = 0.5
	self:invalidateLayout()
end

function PANEL:setVertical(b)

	if self.m_bVertical ~= b then
		self:setSize(self:getH(), self:getW())
		-- self.knob:setSize(self.knob:getH(), self.knob:getW())
		if self.m_bVertical then
			self.m_iLockY = 0.5
			self.m_iLockX = nil
		else
			self.m_iLockY = nil
			self.m_iLockX = 0.5
		end
		self:invalidateLayout()
	end
	self.m_bVertical = b
end
function PANEL:performLayout(width, height)
	local x, y = self:getValue(), self:getValue()
	if self.m_iLockX then
		x = self.m_iLockX
	end
	if self.m_iLockY then
		y = self.m_iLockY
	end
	self:setSlideX(x)
	self:setSlideY(y)
end

function PANEL:paint(x, y, w, h)
	local style = KeGui.Style
	
	local bsize = style.FrameBorderSize
	local round = style.FrameRounding
	render.setMaterial()
	self:paintBorder(x, y, w, h, round)

	if self.used then
		render.setColor(style.FrameBgActive)
	elseif self.hovered then
		render.setColor(style.FrameBgHovered)
	else
		render.setColor(style.FrameBg)
	end
	render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, h - bsize * 2 - 1)

	-- knob

	if self.used then
		render.setColor(style.SliderGrabActive)
	else
		render.setColor(style.SliderGrab)
	end
	local v = self:getValue()
	local s = KeGui.Style.GrabMinSize
	render.drawRoundedBox(style.GrabRounding, math.clamp(x + (w - s) * v, x + 2, x + w - s - 3), y + 2, s, h - 5)

	-- text
	render.setColor(style.Text)
	render.setFont(KeGui.Fonts.main)
	render.drawSimpleText(x + w / 2, y + h / 2, string.format("%.3f", v), 1, 1)

end

function PANEL:onMousePressed(x, y, key, keyName)

	if key == MOUSE.MOUSE1 then
		self.used = true
		self:onMouseMoved(x, y)
		self:mouseCapture(true)
		self:listenRelease(true)
	end
end

function PANEL:onMouseReleased(x, y, key, keyName)
	if key == MOUSE.MOUSE1 then
		self.used = false
		self:mouseCapture(false)
	end
end

function PANEL:setValue(v)

	if self.m_bValue ~= v then
		self.m_bValue = v
		self:_onChange(self.m_bValue)
	end
end

function PANEL:onMouseMoved(x, y)
	x, y = self:screenToLocal(x, y)
	local w, h = self:getSize()
	local iw, ih = KeGui.Style.GrabMinSize, h
	w = w - iw
	h = h - ih

	x = x - iw * 0.5
	y = y - ih * 0.5

	x = math.clamp(x, 0, w) / w
	y = math.clamp(y, 0, h) / h
	if self.m_iLockX then
		x = self.m_iLockX
	end
	if self.m_iLockY then
		y = self.m_iLockY
	end

	x, y = self:translateValues(x, y)
	self:setSlideX(x)
	self:setSlideY(y)
	if self.m_bVertical then
		self:setValue(y)
	else
		self:setValue(x)
	end
	self:invalidateLayout()
end

function PANEL:_onChange(newValue)
	self:onChange(newValue)
	self:invalidateLayout()
end
function PANEL:onChange(newValue)
end

function PANEL:translateValues(x, y)

	-- Give children the chance to manipulate the values..
	return x, y

end
KeGui.register("Slider", PANEL, "Panel")
