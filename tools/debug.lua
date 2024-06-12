---@include ../kegui.lua
require("../kegui.lua")
---TODO
-- 

local x, y = render.getResolution()
local tree = KeGui.new("tree")

tree:setTitle("DEBUG")
tree:setDrawBG(true)

local renderTree, eventsTree
local last
local function recursive(tree, prev)
	if not prev or prev == renderTree or prev:getParent() == renderTree then
		return
	end
	if prev._firstChild then
		local newtree = tree:addNode("Tree")
		newtree:setTitle(tostring(prev))
		prev:toAllChild(function(next)
			recursive(newtree, next)
			if next._firstChild then
			end
		end)
		newtree:maximize()
	else
		tree:addNode("Label"):setText(prev)
	end
end

local function biba(old, new)
	if not new then
		return
	end
	renderTree:clear()
	recursive(renderTree, new:getParent())
	tree:sizeToAllChildren(true, true)
	tree:align()
	renderTree:sizeToAllChildren(true, true)
	last = new

end

eventsTree = tree:addNode("tree")
eventsTree:setPos(4, 28)
eventsTree:setTitle("Events")
local function resolveHook(label, hookName, ...)
	if hookName ~= "MOUSE_MOVED" then -- lagait
		biba(_, last)
	end
	local i = {}
	for k, v in ipairs({...}) do
		table.insert(i, tostring(v))
	end
	label:setText(hookName .. ": " .. "[" .. table.concat(i, ", ") .. "]")
	eventsTree:sizeToAllChildren(true, true)
	tree:sizeToAllChildren(true, true)
	tree:align()
	tree:setX(x - tree:getW())
end
local i = 0
for k, v in pairs(KeGui.EVENT) do
	i = i + 1
	local label = eventsTree:addNode("label")
	label:setText(v:sub(13) .. ": ")
	hook.add(v, "", function(...)
		resolveHook(label, v:sub(13), ...)
	end)
end

renderTree = tree:addNode("tree")
renderTree:setPos(4, 28 * 2)
renderTree:setTitle("Render")

hook.add(KeGui.EVENT.HOVERED, "render.tree", biba)

tree:expandAll()
tree:setX(x - tree:getW())
