---@include panel.lua
require("panel.lua")
local render = render
local PANEL = {}
accessorFunc(PANEL, "m_btitle", "Title", "Tree")

function PANEL:init()

	self.nodes = {}
	self._maximized = true

	self.minmaxButton = self:add("button")
	self.minmaxButton:setText("▾")
	self.minmaxButton.paint = function(p, x, y, w, h)
		local style = KeGui.Style
		if self.disabled then
			render.setColor(style.TextDisabled)
		else
			render.setColor(style.Text)
		end

		x = x + style.FramePadding.x
		y = y - 2

		render.setFont(KeGui.Fonts.main)
		render.drawSimpleText(x, y, p.text, 0, 0)
	end
	self.minmaxButton:setSize(18, 18)
	self.minmaxButton:setAlignY(1)
	self.minmaxButton:alwaysFront(true)
	self.minmaxButton.canhovered = false
	self.minmaxButton.doClick = function()
		self:minimax()
	end
	self:setSize(400, 18)

	self:minimize()
end

function PANEL:getSizeChildren()
	if not self._maximized then
		return self:getSize()
	end
	return self.class.super.getSizeChildren(self)
end

function PANEL:sizeToAllChildren(a, b)
	if not self._maximized then
		return
	end
	return self.class.super.sizeToAllChildren(self, a, b)
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

function PANEL:setW(w)
	self._W = w
	self:invalidateLayout()
end

function PANEL:performLayout(w, h)
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

	self.minmaxButton:setText("⯈")
	self:setSize(self:getW(), 18)
	self:_onMinimized()
end
function PANEL:maximize()
	self._maximized = true

	self.minmaxButton:setText("⯆")
	self:_onMaximized()
end

function PANEL:paint(x, y, w, h)
	local style = KeGui.Style

	local bsize = style.WindowBorderSize
	local round = style.WindowRounding
	self:paintBorder(x, y, w, 18, round)

	-- render.setColor(style.WindowBg)
	-- render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, h - bsize * 2 - 1)

	if self.used then
		render.setColor(style.HeaderActive)
	elseif self.hovered then
		render.setColor(style.HeaderHovered)
	else
		render.setColor(style.Header)
	end
	render.drawRoundedBox(round, x + bsize, y + bsize, w - bsize * 2 - 1, 18 - bsize * 2 - 1)

	render.setColor(style.Text)
	render.setFont(KeGui.Fonts.main)
	render.drawSimpleText(x + 18 + style.FramePadding.x, y, self:getTitle(), 0, 0)

end

function PANEL:addNode(name)
	local node = self:add(name)

	if node._onMinimized then
		local oldmin = node._onMinimized
		function node._onMinimized(...)
			oldmin(...)

			self:_onMinimized(true)
		end
	end

	if node._onMaximized then
		local oldmax = node._onMaximized
		function node._onMaximized(...)
			oldmax(...)
			self:_onMaximized(true)
		end
	end

	node:setW(self:getW() - 22)
	table.insert(self.nodes, node)
	self:calcHeight()
	if self:isMinimized() then
		node[self.address] = node.visible
		node.visible = false
	end
	return node
end

function PANEL:clear()
	for k, v in ipairs(self.nodes) do
		v:remove()
	end
	self.nodes = {}
end

function PANEL:_onMinimized(b)
	if not b then
		local address = self.address
		self:toAllChild(function(child)
			if child == self.minmaxButton then
				return
			end
			child[address] = child.visible
			child.visible = false
		end)
	end

	self:calcHeight()
	self:sizeToAllChildren(false, true)
	if b then
		return
	end
	self:onMinimized()
	self:onMinMax()
end

function PANEL:_onMaximized(b)
	if not b then
		local address = self.address
		self:toAllChild(function(child)
			if child == self.minmaxButton then
				return
			end
			child.visible = child[address]
		end)
	end

	self:calcHeight()
	self:sizeToAllChildren(false, true)
	if b then
		return
	end
	self:onMaximized()
	self:onMinMax()
end

function PANEL:onMinimized()
end

function PANEL:onMaximized()
end

function PANEL:onMinMax()
end

function PANEL:expandAll()
	self:maximize()
	for k, v in ipairs(self.nodes) do
		if v.maximize then
			v:maximize()
		end
	end
end

function PANEL:align()
	for k, v in ipairs(self.nodes) do
		v:setW(self:getW() - 22)
	end
end

function PANEL:performLayout(w, h)
	self.minmaxButton:setSize(w, 18)
end

function PANEL:calcHeight()
	local size = 20
	for k, node in ipairs(self.nodes) do
		local h = node:getH()
		node:setPos(22, size)
		node:setW(self:getW() - 22)
		size = size + h + 2
	end
	return size
end

KeGui.register("Tree", PANEL, "Panel")
