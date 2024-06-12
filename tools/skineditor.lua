---@include ../kegui.lua
require("../kegui.lua")

local window = KeGui.new("Window")
window:setTitle("Skin editor")
window:setSizable(false)

local scroll = window:add("ScrollPanel")

local i = 1
for k, v in pairs(KeGui.Style) do
	if not istable(v) or not v.a then
		goto c
	end

	local i1 = scroll:add("ColorEdit4")

	local i2 = i1:add("Label")
	i2:setPos(256, 0)
	i2:setText(k)
	i1:setW(256 + i2:getW())
	function i1:onChanged(clr)
		KeGui.Style[k] = clr
	end
	function i1:performLayout(width, height)
		self:setColor(KeGui.Style[k])
	end
	i = i + 1
	::c::
end

scroll:setPos(4, 24)
scroll:setSize(512, 512)

local filenameInput = window:add("Input")
filenameInput:setPos(4, 24 + 512 + 2)
filenameInput:setPlaceholder("File Name")

local savebutton = window:add("Button")
savebutton:setText("Save")
savebutton:setPos(filenameInput:getW() + 8, 24 + 512 + 2)
savebutton:setAlign(1)
function savebutton:doClick()
	file.createDir("KeGui/styles")
	local order = {
		"Alpha",
		"DisabledAlpha",
		"WindowPadding",
		"WindowRounding",
		"WindowBorderSize",
		"WindowMinSize",
		"WindowTitleAlign",
		"WindowMenuButtonPosition",
		"ChildRounding",
		"ChildBorderSize",
		"PopupRounding",
		"PopupBorderSize",
		"FramePadding",
		"FrameRounding",
		"FrameBorderSize",
		"ItemSpacing",
		"ItemInnerSpacing",
		"CellPadding",
		"IndentSpacing",
		"ColumnsMinSpacing",
		"ScrollbarSize",
		"ScrollbarRounding",
		"GrabMinSize",
		"GrabRounding",
		"TabRounding",
		"TabBorderSize",
		"TabMinWidthForCloseButton",
		"ColorButtonPosition",
		"ButtonTextAlign",
		"SelectableTextAlign",
		"\n",
		"Text",
		"TextDisabled",
		"WindowBg",
		"ChildBg",
		"PopupBg",
		"Border",
		"BorderShadow",
		"FrameBg",
		"FrameBgHovered",
		"FrameBgActive",
		"TitleBg",
		"TitleBgActive",
		"TitleBgCollapsed",
		"MenuBarBg",
		"ScrollbarBg",
		"ScrollbarGrab",
		"ScrollbarGrabHovered",
		"ScrollbarGrabActive",
		"CheckMark",
		"SliderGrab",
		"SliderGrabActive",
		"Button",
		"ButtonHovered",
		"ButtonActive",
		"Header",
		"HeaderHovered",
		"HeaderActive",
		"Separator",
		"SeparatorHovered",
		"SeparatorActive",
		"ResizeGrip",
		"ResizeGripHovered",
		"ResizeGripActive",
		"Tab",
		"TabHovered",
		"TabActive",
		"TabUnfocused",
		"TabUnfocusedActive",
		"PlotLines",
		"PlotLinesHovered",
		"PlotHistogram",
		"PlotHistogramHovered",
		"TableHeaderBg",
		"TableBorderStrong",
		"TableBorderLight",
		"TableRowBg",
		"TableRowBgAlt",
		"TextSelectedBg",
		"DragDropTarget",
		"NavHighlight",
		"NavWindowingHighlight",
		"NavWindowingDimBg",
		"ModalWindowDimBg",
	}
	local serial = {}
	local style = KeGui.Style
	for _, k in pairs(order) do
		local v = style[k]
		print(k, v)
		if istable(v) and v.a then
			table.insert(serial, '\tstyle["' .. k .. '"] = ImVec4(' .. v.r / 255 .. ", " .. v.g / 255 .. ", " .. v.b / 255 .. ", " .. v.a / 255 .. ')')
		elseif istable(v) and not v.a then
			table.insert(serial, '\tstyle.' .. k .. ' = ImVec2(' .. v[1] .. ", " .. v[2] .. ')')
		else
			if k == "\n" then
				table.insert(serial, "")
			else
				table.insert(serial, '\tstyle.' .. k .. ' = ' .. v)
			end
		end
	end

	file.write("KeGui/styles/" .. filenameInput:getText() .. ".txt", [[
return function()
    local style = {}

]] .. table.concat(serial, "\n") .. [[

    return style
end
]])

end
window:setSize(512 + 4, 24 + 512 + 6 + 24)
