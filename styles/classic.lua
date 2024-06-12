return function()
	local style = {}

	style.Alpha = 1.0
	style.DisabledAlpha = 0.6000000238418579
	style.WindowPadding = ImVec2(8.0, 8.0)
	style.WindowRounding = 0.0
	style.WindowBorderSize = 1.0
	style.WindowMinSize = ImVec2(32.0, 32.0)
	style.WindowTitleAlign = ImVec2(0.0, 0.5)
	style.WindowMenuButtonPosition = KeGuiDir_Left
	style.ChildRounding = 0.0
	style.ChildBorderSize = 1.0
	style.PopupRounding = 0.0
	style.PopupBorderSize = 1.0
	style.FramePadding = ImVec2(4.0, 3.0)
	style.FrameRounding = 0.0
	style.FrameBorderSize = 0.0
	style.ItemSpacing = ImVec2(8.0, 4.0)
	style.ItemInnerSpacing = ImVec2(4.0, 4.0)
	style.CellPadding = ImVec2(4.0, 2.0)
	style.IndentSpacing = 21.0
	style.ColumnsMinSpacing = 6.0
	style.ScrollbarSize = 14.0
	style.ScrollbarRounding = 9.0
	style.GrabMinSize = 10.0
	style.GrabRounding = 0.0
	style.TabRounding = 4.0
	style.TabBorderSize = 0.0
	style.TabMinWidthForCloseButton = 0.0
	style.ColorButtonPosition = KeGuiDir_Right;
	style.ButtonTextAlign = ImVec2(0.5, 0.5)
	style.SelectableTextAlign = ImVec2(0.0, 0.0)

	style["Text"] = ImVec4(0.90, 0.90, 0.90, 1.00)
	style["TextDisabled"] = ImVec4(0.60, 0.60, 0.60, 1.00)
	style["WindowBg"] = ImVec4(0.00, 0.00, 0.00, 0.85)
	style["ChildBg"] = ImVec4(0.00, 0.00, 0.00, 0.00)
	style["PopupBg"] = ImVec4(0.11, 0.11, 0.14, 0.92)
	style["Border"] = ImVec4(0.50, 0.50, 0.50, 0.50)
	style["BorderShadow"] = ImVec4(0.00, 0.00, 0.00, 0.00)
	style["FrameBg"] = ImVec4(0.43, 0.43, 0.43, 0.39)
	style["FrameBgHovered"] = ImVec4(0.47, 0.47, 0.69, 0.40)
	style["FrameBgActive"] = ImVec4(0.42, 0.41, 0.64, 0.69)
	style["TitleBg"] = ImVec4(0.27, 0.27, 0.54, 0.83)
	style["TitleBgActive"] = ImVec4(0.32, 0.32, 0.63, 0.87)
	style["TitleBgCollapsed"] = ImVec4(0.40, 0.40, 0.80, 0.20)
	style["MenuBarBg"] = ImVec4(0.40, 0.40, 0.55, 0.80)
	style["ScrollbarBg"] = ImVec4(0.20, 0.25, 0.30, 0.60)
	style["ScrollbarGrab"] = ImVec4(0.40, 0.40, 0.80, 0.30)
	style["ScrollbarGrabHovered"] = ImVec4(0.40, 0.40, 0.80, 0.40)
	style["ScrollbarGrabActive"] = ImVec4(0.41, 0.39, 0.80, 0.60)
	style["CheckMark"] = ImVec4(0.90, 0.90, 0.90, 0.50)
	style["SliderGrab"] = ImVec4(1.00, 1.00, 1.00, 0.30)
	style["SliderGrabActive"] = ImVec4(0.41, 0.39, 0.80, 0.60)
	style["Button"] = ImVec4(0.35, 0.40, 0.61, 0.62)
	style["ButtonHovered"] = ImVec4(0.40, 0.48, 0.71, 0.79)
	style["ButtonActive"] = ImVec4(0.46, 0.54, 0.80, 1.00)
	style["Header"] = ImVec4(0.40, 0.40, 0.90, 0.45)
	style["HeaderHovered"] = ImVec4(0.45, 0.45, 0.90, 0.80)
	style["HeaderActive"] = ImVec4(0.53, 0.53, 0.87, 0.80)
	style["Separator"] = ImVec4(0.50, 0.50, 0.50, 0.60)
	style["SeparatorHovered"] = ImVec4(0.60, 0.60, 0.70, 1.00)
	style["SeparatorActive"] = ImVec4(0.70, 0.70, 0.90, 1.00)
	style["ResizeGrip"] = ImVec4(1.00, 1.00, 1.00, 0.10)
	style["ResizeGripHovered"] = ImVec4(0.78, 0.82, 1.00, 0.60)
	style["ResizeGripActive"] = ImVec4(0.78, 0.82, 1.00, 0.90)
	style["Tab"] = ImLerp(style["Header"], style["TitleBgActive"], 0.80)
	style["TabHovered"] = style["HeaderHovered"]
	style["TabActive"] = ImLerp(style["HeaderActive"], style["TitleBgActive"], 0.60)
	style["TabUnfocused"] = ImLerp(style["Tab"], style["TitleBg"], 0.80)
	style["TabUnfocusedActive"] = ImLerp(style["TabActive"], style["TitleBg"], 0.40)
	style["PlotLines"] = ImVec4(1.00, 1.00, 1.00, 1.00)
	style["PlotLinesHovered"] = ImVec4(0.90, 0.70, 0.00, 1.00)
	style["PlotHistogram"] = ImVec4(0.90, 0.70, 0.00, 1.00)
	style["PlotHistogramHovered"] = ImVec4(1.00, 0.60, 0.00, 1.00)
	style["TableHeaderBg"] = ImVec4(0.27, 0.27, 0.38, 1.00)
	style["TableBorderStrong"] = ImVec4(0.31, 0.31, 0.45, 1.00)
	style["TableBorderLight"] = ImVec4(0.26, 0.26, 0.28, 1.00)
	style["TableRowBg"] = ImVec4(0.00, 0.00, 0.00, 0.00)
	style["TableRowBgAlt"] = ImVec4(1.00, 1.00, 1.00, 0.07)
	style["TextSelectedBg"] = ImVec4(0.00, 0.00, 1.00, 0.35)
	style["DragDropTarget"] = ImVec4(1.00, 1.00, 0.00, 0.90)
	style["NavHighlight"] = style["HeaderHovered"]
	style["NavWindowingHighlight"] = ImVec4(1.00, 1.00, 1.00, 0.70)
	style["NavWindowingDimBg"] = ImVec4(0.80, 0.80, 0.80, 0.20)
	style["ModalWindowDimBg"] = ImVec4(0.20, 0.20, 0.20, 0.35)
	return style
end
