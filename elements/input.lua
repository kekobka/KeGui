if SERVER then
	return
end
---@include button.lua
require("button.lua")
local min = math.min

local PANEL = {}

accessorFunc(PANEL, "m_bPlaceholder", "Placeholder", "InputText")
accessorFunc(PANEL, "m_bXOffset", "XOffset", 1)
accessorFunc(PANEL, "m_bYOffset", "YOffset", 0)
accessorFunc(PANEL, "m_bNumeric", "Numeric", false)
accessorFunc(PANEL, "m_bMaxInput", "MaxInput", -1)

function PANEL:init()
	self.alignX = 0
	self.alignY = 1
	self:setText(self:getPlaceholder())
	self:setSize(128, 24)
	self.carettime = 0
end

function PANEL:paint(x, y, w, h)
	local style = KeGui.Style

	if self.drawbg then
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
	end

	render.setColor(style.Text)
	render.setFont(self.font)
	local t = self:getText()
	if self.editing then
		self.carettime = min(1, self.carettime + timer.frametime()) % 1
		if self.carettime == 0 then
			self.caret = not self.caret
		end
		if self.caret then
			t = self.text .. "▏"
		else
			t = self.text
		end
		render.drawSimpleText(min(x - self._textWidth + w - 5, x + 3), y + (self.alignY == 1 and h / 2 or 1), t, 0, self.alignY)
	else
		local x = x + (self.alignX == 1 and w / 2 or 1)
		local y = y + (self.alignY == 1 and h / 2 or 1)
		render.drawSimpleText(x, y, t, self.alignX, self.alignY)
	end
end

function PANEL:onMousePressed(x, y, key, keyName)
	if key == MOUSE.MOUSE1 or key == MOUSE.MOUSE2 then
		self:setUsed(true)
	end
end

function PANEL:onMouseReleased(x, y, key, keyName)
	if key == MOUSE.MOUSE2 and self:isUsed() then
		self:onRightClick()
		self:setUsed(false)
	elseif key == MOUSE.MOUSE1 and self:isUsed() then
		self:doClick()
		local address = self.address
		notification.addLegacy("Open Chat", NOTIFY.HINT, 2)
		hook.add("StartChat", "KeGui.event_listener." .. address, function(key, keyName)
			self.editing = true
			hook.add("ChatTextChanged", "KeGui.event_listener." .. address, function(text)
				if self:getMaxInput() > 0 then
					text = string.sub(text, 1, self:getMaxInput())
				end
				if self:getNumeric() then
					text = tonumber(text) or ""
				end
				self:setText(text)
			end)
			hook.add("PlayerChat", "KeGui.event_listener." .. address, function(ply)
				hook.remove("PlayerChat", "KeGui.event_listener." .. address)
				if ply == player() then
					return true
				end
			end)
			hook.add("FinishChat", "KeGui.event_listener." .. address, function()
				self.editing = false
				hook.remove("StartChat", "KeGui.event_listener." .. address)
				hook.remove("ChatTextChanged", "KeGui.event_listener." .. address)
				hook.remove("FinishChat", "KeGui.event_listener." .. address)
				timer.simple(1, function()
					hook.remove("PlayerChat", "KeGui.event_listener." .. address)
				end)
				if self.text == "" then
					self:setText(self:getPlaceholder())
					self:onFinish()
				else
					self:onFinish(self.text)
				end
				self:setUsed(false)
			end)
		end)
	end
end

function PANEL:onMouseLeave()
	if not self.editing then
		self:setUsed(false)
	end
	hook.remove("StartChat", "KeGui.event_listener." .. self.address)
end

function PANEL:onRightClick()
	self:setText(self:getPlaceholder())
	self:onFinish()
end
function PANEL:setPlaceholder(t)
	self:setText(t)
	self.m_bPlaceholder = t
end
function PANEL:onFinish(text)
end

KeGui.register("Input", PANEL, "Button")
