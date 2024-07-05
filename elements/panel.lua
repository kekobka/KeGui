if SERVER then
	return
end
local PANEL = {}
accessorFunc(PANEL, "_X", "X", 0)
accessorFunc(PANEL, "_Y", "Y", 0)
accessorFunc(PANEL, "_W", "W", 0)
accessorFunc(PANEL, "_H", "H", 0)

local table_address = table.address
local table_concat = table.concat
local table_insert = table.insert
local table_empty = table.empty
local math_max = math.max

function PANEL:initialize()
	self._parent = nil
	self._firstChild = nil
	self._prevSibling = nil
	self._nextSibling = nil
	self.visible = true
	self.enabled = true
	self.address = table_address(self)
	self.canhovered = true
end

local ___t = {}

function PANEL:__tostring()
	table_insert(___t, self.name or self.class.name)
	table_insert(___t, "_")
	table_insert(___t, self.address)
	table_insert(___t, "[")
	table_insert(___t, self._X)
	table_insert(___t, ", ")
	table_insert(___t, self._Y)
	table_insert(___t, ", ")
	table_insert(___t, self._W)
	table_insert(___t, ", ")
	table_insert(___t, self._H)
	table_insert(___t, "]")
	local s = table_concat(___t)
	table_empty(___t)
	return s
end

local floor = math.floor
function PANEL:setX(x)
	self._X = floor(x)
end

function PANEL:setY(y)
	self._Y = floor(y)
end

function PANEL:getPos()
	return self:getX(), self:getY()
end

function PANEL:getAbsolutePos(x, y)
	x = x == nil and self:getX() or x + self:getX()
	y = y == nil and self:getY() or y + self:getY()

	if self:hasParent() then
		x, y = self:getParent():getAbsolutePos(x, y)
	end
	return x, y
end

function PANEL:setPos(x, y)
	self:setX(x)
	self:setY(y)
end

function PANEL:center()
	local p = self:getParent()
	self:setX(p:getW() / 2 - self:getW() / 2)
	self:setY(p:getH() / 2 - self:getH() / 2)
end

function PANEL:setW(w)
	self._W = floor(w)
end

function PANEL:setH(h)
	self._H = floor(h)
end

function PANEL:setSize(w, h)
	self:setW(w)
	self:setH(h)
end

function PANEL:getSize()
	return self:getW(), self:getH()
end

function PANEL:invalidateLayoutRecursive()
	if not self._firstChild then
		return self:invalidateLayout()
	end

	local temp = self._firstChild

	temp:invalidateLayoutRecursive()
	while temp._nextSibling do
		temp = temp._nextSibling
		temp:invalidateLayoutRecursive()
	end

	self:invalidateLayout()
end

function PANEL:getSizeChildren()
	self:invalidateLayout()

	if not self._firstChild then
		return self:getSize()
	end

	local temp = self._firstChild
	local w, h = temp:getSizeChildren()

	while temp._nextSibling do
		temp = temp._nextSibling
		local w1, h1 = temp:getSizeChildren()

		w, h = math_max(w, temp:getX() + w1), math_max(h, temp:getY() + h1)
	end
	local w1, h1 = self:getSize()

	return math_max(w, w1), math_max(h, h1)
end

function PANEL:sizeToChildren(sizeW, sizeH)
	if not self._firstChild then
		return
	end

	local temp = self._firstChild
	local w, h = temp:getSize()

	while temp._nextSibling do
		temp = temp._nextSibling
		local w1, h1 = temp:getSize()

		w, h = math_max(w, temp:getX() + w1), math_max(h, temp:getY() + h1)
	end

	if sizeW then
		self:setW(w)
	end

	if sizeH then
		self:setH(h)
	end
	self:invalidateLayout()
end

function PANEL:sizeToAllChildren(sizeW, sizeH)

	self:invalidateLayout()

	if not self._firstChild then
		return
	end

	local temp = self._firstChild
	local w, h = temp:getSizeChildren()

	while temp._nextSibling do
		temp = temp._nextSibling
		local w1, h1 = temp:getSizeChildren()

		w, h = math_max(w, temp:getX() + w1), math_max(h, temp:getY() + h1)
	end

	if sizeW then
		self:setW(w)
	end

	if sizeH then
		self:setH(h)
	end

end

function PANEL:sizeToChildrenRecursive(sizeW, sizeH)
	if not self._firstChild then
		return
	end

	local temp = self._firstChild
	local w, h = temp:getSizeChildren()
	temp:sizeToChildrenRecursive(sizeW, sizeH)

	while temp._nextSibling do
		temp = temp._nextSibling
		local w1, h1 = temp:getSizeChildren()
		temp:sizeToChildrenRecursive(sizeW, sizeH)

		w, h = math_max(w, temp:getX() + w1), math_max(h, temp:getY() + h1)
	end

	if sizeW then
		self:setW(w)
	end

	if sizeH then
		self:setH(h)
	end
	self:invalidateLayout()
end

function PANEL:add(name)
	if not name then
		return throw("is not element")
	end

	local el = KeGui.new(name, self)
	return el

end
function PANEL:remove()
	local parent = self:getParent()
	if not self._prevSibling then
		parent._firstChild = nil
		return
	end

	local prev = self._prevSibling
	local next = self._nextSibling

	prev._nextSibling = next
	if next then
		next._prevSibling = prev
	end
end
function PANEL:addChild(child)
	child:setParent(self)

	if not self._firstChild then
		self._firstChild = child
	else
		local temp = self._firstChild

		while temp._nextSibling do
			temp = temp._nextSibling
		end

		temp._nextSibling = child
		child._prevSibling = temp
	end
end

function PANEL:toAllChild(fn)
	local temp = self._firstChild

	while temp do
		local next = temp._nextSibling

		if fn(temp) then
			return temp
		end

		temp = next
	end

	return nil
end

function PANEL:disable()
	self.enabled = false
end

function PANEL:enable()
	self.enabled = true
end

function PANEL:isCaptured()
	return self.m_bMouseCapture
end
function PANEL:mouseCapture(doCapture)
	self.m_bMouseCapture = doCapture

	if doCapture then
		hook.add("KeGui.POSTMOUSE_WHEELED", "KeGui.event_listener." .. self.address, function(x, y, delta)
			self:onMouseWheeled(x, y, delta)
		end)
		hook.add("KeGui.MOUSE_POSTPRESSED", "KeGui.event_listener." .. self.address, function(x, y, key, keyName)
			self:onMousePressed(x, y, key, keyName)
		end)
		hook.add("KeGui.MOUSE_POSTRELEASED", "KeGui.event_listener." .. self.address, function(x, y, key, keyName)
			self:onMouseReleased(x, y, key, keyName)
		end)
		hook.add("KeGui.POSTMOUSE_MOVED", "KeGui.event_listener." .. self.address, function(x, y)
			self:onMouseMoved(x, y)
		end)

	else
		hook.remove("KeGui.POSTMOUSE_WHEELED", "KeGui.event_listener." .. self.address)
		hook.remove("KeGui.MOUSE_POSTPRESSED", "KeGui.event_listener." .. self.address)
		hook.remove("KeGui.MOUSE_POSTRELEASED", "KeGui.event_listener." .. self.address)
		hook.remove("KeGui.POSTMOUSE_MOVED", "KeGui.event_listener." .. self.address)
	end

end

function PANEL:listenRelease(doCapture)
	if doCapture then
		hook.add("KeGui.MOUSE_POSTRELEASED", "KeGui.event_listener." .. self.address, function(x, y, key, keyName)
			local keyName = input.getKeyName(key)
			if key == MOUSE.MOUSE1 then
				self:onMouseReleased(x, y, key, keyName)
				hook.remove("KeGui.MOUSE_POSTRELEASED", "KeGui.event_listener." .. self.address)
			end
		end)
	else
		hook.remove("KeGui.MOUSE_POSTRELEASED", "KeGui.event_listener." .. self.address)
	end
end

function PANEL:screenToLocal(x, y)
	local px, py = self:getAbsolutePos()
	return x - px, y - py
end

function PANEL:localToScreen(x, y)
	local px, py = self:getAbsolutePos()
	return x + px, y + py
end

function PANEL:setParent(parent)
	self._parent = parent
end

function PANEL:getParent()
	return self._parent
end

function PANEL:hasParent()
	return self:getParent() ~= nil
end

function PANEL:moveToFront()

	local next = self._nextSibling
	local prev = self._prevSibling

	if not prev then
		return
	end

	if prev._alwaysFront then
		return
	end
	prev._nextSibling = next

	if next then
		next._prevSibling = prev
	end
	local parent = self:getParent()

	local first = parent._firstChild
	if first then

		self._nextSibling = parent._firstChild
		parent._firstChild._prevSibling = self
		self._prevSibling = nil
		parent._firstChild = self

		if first._alwaysFront then
			if first then
				first:moveToFront()
			end
		end
	end
end

function PANEL:isAbove()
	if self._prevSibling then
		return self._prevSibling._alwaysFront
	end
	return self._prevSibling == nil
end

function PANEL:cursorIntersect(x, y)
	local aX, aY = self:getAbsolutePos()

	if x >= aX and x < aX + self:getW() and y >= aY and y < aY + self:getH() then
		return true
	end

	return false
end

function PANEL:cursorIntersectHovered(x, y)
	-- Override
	return true
end

PANEL.events = {
	[EVENT.THINK] = function(self, ...)
		return self:_onThink(self, ...)
	end,
	[EVENT.MOUSE_PRESSED] = function(self, ...)
		return self:_onMousePressed(...)
	end,
	[EVENT.MOUSE_RELEASED] = function(self, ...)
		return self:_onMouseReleased(...)
	end,
	[EVENT.BUTTON_PRESSED] = function(self, ...)
		return self:_onButtonPressed(...)
	end,
	[EVENT.BUTTON_RELEASED] = function(self, ...)
		return self:_onButtonReleased(...)
	end,
	[EVENT.MOUSE_MOVED] = function(self, ...)
		return self:_onMouseMoved(...)
	end,
	[EVENT.MOUSE_WHEELED] = function(self, ...)
		return self:_onMouseWheeled(...)
	end,

}
function PANEL:_postEvent(eventKey, ...)
	local event = PANEL.events[eventKey]
	if event then
		return event(self, ...)
	end
end

function PANEL:_postEventToAll(eventKey, ...)
	local temp = self._firstChild

	while temp do
		local next = temp._nextSibling

		if temp:_postEvent(eventKey, ...) then
			return temp
		end

		temp = next
	end

	return nil
end

function PANEL:_postEventToAllFull(eventKey, ...)
	local temp = self._firstChild
	local ret = nil
	while temp do
		local next = temp._nextSibling

		if temp:_postEvent(eventKey, ...) then
			ret = temp
		end

		temp = next
	end

	return ret
end

function PANEL:_postEventToAllReverseRender(x, y, w, h)
	local next = self._nextSibling

	if next then
		next:_postEventToAllReverseRender(x, y, w, h)
	end

	self:_onRender(x, y, w, h, self.m_benableScissor)

	return nil
end
function PANEL:_postEventToAllReverseThink()
	local next = self._nextSibling

	if next then
		next:_postEventToAllReverseThink()
	end

	self:_onThink()

	return nil
end
local render_enableScissorRect = render.enableScissorRect
local render_disableScissorRect = render.disableScissorRect
local max, min = math.max, math.min
function PANEL:_onRender(X, Y, W, H, st)
	if not self.visible then
		return
	end

	local x, y = self:getAbsolutePos()
	local w, h = self:getSize()
	local dx, dy, dw, dh = max(x, X), max(y, Y), min(x + w, W), min(y + h, H)
	if dx > dw or dy > dh then
		return
	end

	render_enableScissorRect(dx, dy, dw, dh)
	self:paint(x, y, w, h)
	render_disableScissorRect()

	if self._firstChild then
		self._firstChild:_postEventToAllReverseRender(dx, dy, dw, dh)
	end
	self:postChildPaint(x, y, w, h)
end
local render_setColor = render and render.setColor
local render_drawRectOutline = render and render.drawRectOutline
local render_drawRectFast = render and render.drawRectFast
local render_drawRoundedBoxOutlined = render and render.drawRoundedBoxOutlined
local KeGui = KeGui
function PANEL:paint(x, y, w, h)
	render_setColor(KeGui.Style.WindowBg)
	render_drawRectFast(x, y, w, h)
end

function PANEL:paintBorder(x, y, w, h, r)
	local style = KeGui.Style
	local border = style.Border
	local borderShadow = style.BorderShadow

	if r <= 0 then
		if border.a > 0 then
			render_setColor(border)
			render_drawRectOutline(x, y, w - 1, h - 1, 1)
		end
		if borderShadow.a > 0 then
			render_setColor(borderShadow)
			render_drawRectOutline(x + 2, y + 2, w - 3, h - 3, 1)
		end
		return
	end
	if border.a > 0 then
		render_drawRoundedBoxOutlined(r, x, y, w - 1, h - 1, 1, border)
	end

	if borderShadow.a > 0 then
		render_drawRoundedBoxOutlined(r, x + 1, y + 1, w - 3, h - 3, 1, borderShadow)
	end
end

function PANEL:alwaysFront(bool)
	self._alwaysFront = bool
	if bool then
		self:moveToFront()
	end
end

function PANEL:postChildPaint(x, y, w, h)
end

function PANEL:_onMouseMoved(x, y)

	if self:cursorIntersect(x, y) then
		if not self.enabled then
			return self:_postEventToAll(EVENT.MOUSE_MOVED, x, y)
		end
		if self.visible and self.canhovered then
			local element = self:_postEventToAll(EVENT.MOUSE_MOVED, x, y)

			if not element then
				if not self.hovered then
					if self:cursorIntersectHovered(x, y) then
						self.hovered = true
					end
					self:_onMouseEnter()
				end
				hook.run(KeGui.EVENT.MOUSE_MOVED, self, x, y)
			end

			return true
		end
	else
		return false
	end
end

function PANEL:_onMousePressed(x, y, key, keyName)

	if self:cursorIntersect(x, y) then
		if not self.enabled then
			return self:_postEventToAll(EVENT.MOUSE_PRESSED, x, y, key, keyName)
		end
		if self.visible then
			local element = self:_postEventToAll(EVENT.MOUSE_PRESSED, x, y, key, keyName)

			if not element then
				self:onMousePressed(x, y, key, keyName)

				if self:hasParent() then
					self:moveToFront()
				end
				hook.run(KeGui.EVENT.MOUSE_PRESSED, self, x, y, key, keyName)
			end

			return true
		end
	else
		return false
	end
end

function PANEL:_onMouseReleased(x, y, key, keyName)

	if self:cursorIntersect(x, y) then
		if not self.enabled then
			return self:_postEventToAll(EVENT.MOUSE_RELEASED, x, y, key, keyName)
		end
		if self.visible then
			local element = self:_postEventToAll(EVENT.MOUSE_RELEASED, x, y, key, keyName)

			if not element then
				self:onMouseReleased(x, y, key, keyName)
				hook.run(KeGui.EVENT.MOUSE_RELEASED, self, x, y, key, keyName)
			end

			return true
		end
		return false
	end
end

function PANEL:_onThink()
	if self.enabled and self.visible then
		self:think()

		if self._firstChild then
			self._firstChild:_postEventToAllReverseThink()
		end
	end
end
function PANEL:_onMouseWheeled(x, y, delta)

	if self:cursorIntersect(x, y) then
		if not self.enabled then
			return self:_postEventToAll(EVENT.MOUSE_WHEELED, x, y, delta)
		end

		if self.visible then
			local element = self:_postEventToAll(EVENT.MOUSE_WHEELED, x, y, delta)

			if not element then
				self:onMouseWheeled(x, y, delta)
				hook.run(KeGui.EVENT.MOUSE_WHEELED, self, x, y, delta)
			end

			return true
		end
		return false
	end
end

function PANEL:onMouseWheeled(x, y, key, keyName)
end

function PANEL:onMouseMoved(x, y)
end

function PANEL:think()
end

function PANEL:_onMouseEnter()
	if KeGui.lastHovered ~= self then
		if KeGui.lastHovered then
			KeGui.lastHovered.hovered = false

			KeGui.lastHovered:_onMouseLeave()
		end
		hook.run(KeGui.EVENT.HOVERED, KeGui.lastHovered or self, self)
		KeGui.lastHovered = self
		self:onMouseEnter()
	end
end

function PANEL:onMouseEnter()
end

function PANEL:_onMouseLeave()
	self:onMouseLeave()
end

function PANEL:onMouseLeave()
end

function PANEL:onButtonPressed(key, keyName)
end

function PANEL:onButtonReleased(key, keyName)
end

function PANEL:_onButtonPressed(key, keyName)
end

function PANEL:_onButtonReleased(key, keyName)
end

function PANEL:onMousePressed(x, y, key, keyName)
end

function PANEL:onMouseReleased(x, y, key, keyName)
end

function PANEL:performLayout(w, h)
end

function PANEL:invalidateLayout()
	self:performLayout(self:getSize())
end

local remap = math.remap
local dummy = function(x)
	return x
end
function PANEL:sizeTo(sizeW, sizeH, speed, delay, ease, callback)
	ease = ease or dummy
	local startW, startH = self:getSize()
	KeGui.newAnimation(speed, delay, function(progress)
		local w = remap(ease(progress), 0, 1, startW, sizeW)
		local h = remap(ease(progress), 0, 1, startH, sizeH)
		self:setSize(w, h)
	end, callback)
end

KeGui.register("Panel", PANEL)
