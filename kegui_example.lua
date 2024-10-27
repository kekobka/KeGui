---@owneronly
---@client
---@include kegui.lua
require("kegui.lua")
---@include tools/debug.lua
-- require("tools/debug.lua")
---@include tools/skineditor.lua
-- require("tools/skineditor.lua")
--- @include styles/cherry.lua

enableHud(player(), true)
-- KeGui.registerStyle("cherry", require("styles/cherry.lua"))
KeGui.setStyleFromRepo("cherry")
local panel = KeGui.new("Window")
panel:setSize(1024, 1024)
panel:center()
do
	local p = panel:add("Window")
	p:setSize(100, 100)
	p:setPos(500, 500)
	local p = panel:add("Window")
	p:setSize(100, 100)
	p:setPos(600, 500)

	local p = panel:add("ScrollPanel")
	p:setSize(100, 100)
	p:setPos(600, 100)
	for i = 1, 10, 1 do
		p:add("Button"):setText("Button " .. i)
	end
end
local pisun = panel:add("button")
pisun:setPos(4, 28)
pisun:setAlign(1)
pisun:setText("pisun")
function pisun:doClick()
	print("pisun")
end

local checkbox = panel:add("Checkbox")
checkbox:setPos(4, 28 * 2)
checkbox:sizeToContents()
local slider = panel:add("Slider")
slider:setPos(4, 28 * 3)

local colorPanel = panel:add("ColorEdit4")
colorPanel:setPos(4, 28 * 4)

local plotLines = panel:add("PlotLines")
plotLines:setPos(4, 28 * 5)
local samples = {}
for n = 1, 100, 1 do
	samples[n] = 0
end
local i = 0
hook.add("think", table.address({}), function()
	i = (i % 100) + 1

	samples[i] = math.rand(-1, 1)

	plotLines:setLines(samples)
end)

local scroll = panel:add("Scroll")
scroll:setPos(4, 28 * 6)
scroll:setMax(10)
function scroll:onSelect(id, line)
	KeGui.setStyle(line)
	panel:setTitle(line)
end

for k, v in sortedPairs(KeGui.Styles) do
	scroll:addLine(k)
end

local rendertarget = panel:add("Render")
rendertarget:setPos(512 + 250, 28 * 6 + 4 + scroll:getH())
rendertarget:setSize(256, 256)
rendertarget:setFPS(144)
rendertarget:setRes(512, 512)
function rendertarget:render(w, h)
	render.drawRect(math.random(1, w - 2), math.random(1, h - 2), 2, 2)
end

local tree = panel:add("tree")
tree:setPos(4, 28 * 6 + 4 + scroll:getH())

local tree2 = tree:addNode("tree")
tree2:addNode("button").doClick = print
tree2:addNode("label")
tree2:addNode("Checkbox")
local plotLines = tree2:addNode("PlotLines")
local samples = {}
local slider
hook.add("think", table.address({}), function()
	for n = 1, 100, 1 do
		samples[n] = math.rand(-1, 1) * slider:getValue()
	end
	plotLines:setLines(samples)
end)

local tree2 = tree:addNode("tree")
local scroll = tree2:addNode("scroll")
scroll:setMax(10)
function scroll:onSelect(id, line)
	KeGui.setStyle(line)
	panel:setTitle(line)
end

for k, v in sortedPairs(KeGui.Styles) do
	scroll:addLine(k)
end

slider = tree2:addNode("slider")
tree2:addNode("button")

local tree2 = tree2:addNode("tree")
tree2:addNode("Input")
tree2:addNode("button")
tree2:addNode("Checkbox")
tree:addNode("button")
