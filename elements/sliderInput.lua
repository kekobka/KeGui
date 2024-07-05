if SERVER then
	return
end
---@include input.lua
require("input.lua")
local min = math.min

local PANEL = {}

accessorFunc(PANEL, "m_bValue", "Value", 0.5)
accessorFunc(PANEL, "m_bPlaceholder", "Placeholder", 0)
accessorFunc(PANEL, "m_bMinValue", "MinValue", 0)
accessorFunc(PANEL, "m_bMaxValue", "MaxValue", 1)
accessorFunc(PANEL, "m_bMaxInput", "MaxInput", 0)
accessorFunc(PANEL, "m_bRound", "Round", false)

function PANEL:init()
	self.alignX = 0
	self.alignY = 1
	self:setText(self:getPlaceholder())
	self:setSize(128, 24)
	self.carettime = 0
	self._lastRelease = timer.curtime()
	self._lastposx, self._lastposy = 0, 0
end

function PANEL:onMousePressed(x, y, key, keyName)
	if key == MOUSE.MOUSE2 then
		self:setUsed(true)
	elseif key == MOUSE.MOUSE1 then
		self:setUsed(true)
		self:mouseCapture(true)
		self._lastposx, self._lastposy = self:screenToLocal(x, y)
	end
end

function PANEL:onMouseReleased(x, y, key, keyName)
	if key == MOUSE.MOUSE2 and self:isUsed() then
		self:onRightClick()
		self:setUsed(false)
		self.editing = false
		hook.remove("StartChat", "KeGui.event_listener." .. self.address)
		hook.remove("ChatTextChanged", "KeGui.event_listener." .. self.address)
		hook.remove("FinishChat", "KeGui.event_listener." .. self.address)
		hook.remove("PlayerChat", "KeGui.event_listener." .. self.address)
	elseif key == MOUSE.MOUSE1 and self:isUsed() then
		self:doClick()
		self:mouseCapture(false)
		self:setUsed(false)
		if self.editing then
			self.editing = false
			hook.remove("StartChat", "KeGui.event_listener." .. self.address)
			hook.remove("ChatTextChanged", "KeGui.event_listener." .. self.address)
			hook.remove("FinishChat", "KeGui.event_listener." .. self.address)
			hook.remove("PlayerChat", "KeGui.event_listener." .. self.address)
			return
		end
		if self._lastRelease < timer.curtime() - 0.5 then
			self._lastRelease = timer.curtime()
			return
		end
		self._lastRelease = timer.curtime()
		local address = self.address
		self.editing = true
		hook.add("StartChat", "KeGui.event_listener." .. address, function(key, keyName)
			self.startchat = true
			hook.add("ChatTextChanged", "KeGui.event_listener." .. address, function(text)

				text = tonumber(text) or self:getPlaceholder()
				self:setText(math.clamp(text, self:getMinValue(), self:getMaxValue()))
			end)
			hook.add("PlayerChat", "KeGui.event_listener." .. address, function(ply)
				hook.remove("PlayerChat", "KeGui.event_listener." .. address)
				if ply == player() then
					return true
				end
			end)
			hook.add("FinishChat", "KeGui.event_listener." .. address, function()
				self.editing = false
				self.startchat = false
				hook.remove("StartChat", "KeGui.event_listener." .. address)
				hook.remove("ChatTextChanged", "KeGui.event_listener." .. address)
				hook.remove("FinishChat", "KeGui.event_listener." .. address)
				timer.simple(1, function()
					hook.remove("PlayerChat", "KeGui.event_listener." .. address)
				end)
				if self.text == "" then
					self:_onFinish(self:getPlaceholder())
				else
					self:_onFinish(self.text)
				end
				self:setUsed(false)
			end)
		end)
	end
end

function PANEL:onMouseLeave()
	-- if not self.startchat and not self:isCaptured() then
	-- 	self:setUsed(false)
	-- end
	-- hook.remove("StartChat", "KeGui.event_listener." .. self.address)
end

function PANEL:onMouseMoved(x, y)
	local x1, y1 = self._lastposx, self._lastposy
	x, y = self:screenToLocal(x, y)
	self._lastposx, self._lastposy = x, y
	local w, h = self:getSize()

	if self.m_bVertical then
		y = math.clamp(self:getValue() + (y - y1) / h, 0, 1)
		self:setValue(y)
		self:_onFinish(math.remap(y, 0, 1, self:getMinValue(), self:getMaxValue()))
	else
		x = math.clamp(self:getValue() + (x - x1) / w, 0, 1)
		self:setValue(x)
		self:_onFinish(math.remap(x, 0, 1, self:getMinValue(), self:getMaxValue()))
	end
end

function PANEL:onRightClick()
	self:_onFinish(self:getPlaceholder())
end

function PANEL:_onFinish(text)
	text = tonumber(text) or self:getPlaceholder()
	if self:getRound() then
		text = math.round(text)
	end

	self:setText(math.clamp(text, self:getMinValue(), self:getMaxValue()))
	self:onFinish(text)
end

function PANEL:setText(text)
	text = tonumber(text) or self:getPlaceholder()
	self:setValue(math.remap(text, self:getMinValue(), self:getMaxValue(), 0, 1))
	self.class.super.setText(self, text)
end

function PANEL:onFinish(text)
end

KeGui.register("SliderInput", PANEL, "Input")
