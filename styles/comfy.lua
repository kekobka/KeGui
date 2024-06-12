return function()
	local style = {}

	style.Alpha = 1.0
	style.DisabledAlpha = 0.1000000014901161
	style.WindowPadding = ImVec2(8.0, 8.0)
	style.WindowRounding = 10.0
	style.WindowBorderSize = 0.0
	style.WindowMinSize = ImVec2(30.0, 30.0)
	style.WindowTitleAlign = ImVec2(0.5, 0.5)
	style.WindowMenuButtonPosition = KeGuiDir_Right
	style.ChildRounding = 5.0
	style.ChildBorderSize = 1.0
	style.PopupRounding = 10.0
	style.PopupBorderSize = 0.0
	style.FramePadding = ImVec2(5.0, 3.5)
	style.FrameRounding = 5.0
	style.FrameBorderSize = 0.0
	style.ItemSpacing = ImVec2(5.0, 4.0)
	style.ItemInnerSpacing = ImVec2(5.0, 5.0)
	style.CellPadding = ImVec2(4.0, 2.0)
	style.IndentSpacing = 5.0
	style.ColumnsMinSpacing = 5.0
	style.ScrollbarSize = 15.0
	style.ScrollbarRounding = 9.0
	style.GrabMinSize = 15.0
	style.GrabRounding = 5.0
	style.TabRounding = 5.0
	style.TabBorderSize = 0.0
	style.TabMinWidthForCloseButton = 0.0
	style.ColorButtonPosition = KeGuiDir_Right
	style.ButtonTextAlign = ImVec2(0.5, 0.5)
	style.SelectableTextAlign = ImVec2(0.0, 0.0)

	style["Text"] = ImVec4(1.0, 1.0, 1.0, 1.0)
	style["TextDisabled"] = ImVec4(1.0, 1.0, 1.0, 0.3605149984359741)
	style["WindowBg"] = ImVec4(0.09803921729326248, 0.09803921729326248, 0.09803921729326248, 1.0)
	style["ChildBg"] = ImVec4(1.0, 0.0, 0.0, 0.0)
	style["PopupBg"] = ImVec4(0.09803921729326248, 0.09803921729326248, 0.09803921729326248, 1.0)
	style["Border"] = ImVec4(0.4235294163227081, 0.3803921639919281, 0.572549045085907, 0.54935622215271)
	style["BorderShadow"] = ImVec4(0.0, 0.0, 0.0, 0.0)
	style["FrameBg"] = ImVec4(0.1568627506494522, 0.1568627506494522, 0.1568627506494522, 1.0)
	style["FrameBgHovered"] = ImVec4(0.3803921639919281, 0.4235294163227081, 0.572549045085907, 0.5490196347236633)
	style["FrameBgActive"] = ImVec4(0.6196078658103943, 0.5764706134796143, 0.7686274647712708, 0.5490196347236633)
	style["TitleBg"] = ImVec4(0.09803921729326248, 0.09803921729326248, 0.09803921729326248, 1.0)
	style["TitleBgActive"] = ImVec4(0.09803921729326248, 0.09803921729326248, 0.09803921729326248, 1.0)
	style["TitleBgCollapsed"] = ImVec4(0.2588235437870026, 0.2588235437870026, 0.2588235437870026, 0.0)
	style["MenuBarBg"] = ImVec4(0.0, 0.0, 0.0, 0.0)
	style["ScrollbarBg"] = ImVec4(0.1568627506494522, 0.1568627506494522, 0.1568627506494522, 0.0)
	style["ScrollbarGrab"] = ImVec4(0.1568627506494522, 0.1568627506494522, 0.1568627506494522, 1.0)
	style["ScrollbarGrabHovered"] = ImVec4(0.2352941185235977, 0.2352941185235977, 0.2352941185235977, 1.0)
	style["ScrollbarGrabActive"] = ImVec4(0.294117659330368, 0.294117659330368, 0.294117659330368, 1.0)
	style["CheckMark"] = ImVec4(0.294117659330368, 0.294117659330368, 0.294117659330368, 1.0)
	style["SliderGrab"] = ImVec4(0.6196078658103943, 0.5764706134796143, 0.7686274647712708, 0.5490196347236633)
	style["SliderGrabActive"] = ImVec4(0.8156862854957581, 0.772549033164978, 0.9647058844566345, 0.5490196347236633)
	style["Button"] = ImVec4(0.6196078658103943, 0.5764706134796143, 0.7686274647712708, 0.5490196347236633)
	style["ButtonHovered"] = ImVec4(0.7372549176216125, 0.6941176652908325, 0.886274516582489, 0.5490196347236633)
	style["ButtonActive"] = ImVec4(0.8156862854957581, 0.772549033164978, 0.9647058844566345, 0.5490196347236633)
	style["Header"] = ImVec4(0.6196078658103943, 0.5764706134796143, 0.7686274647712708, 0.5490196347236633)
	style["HeaderHovered"] = ImVec4(0.7372549176216125, 0.6941176652908325, 0.886274516582489, 0.5490196347236633)
	style["HeaderActive"] = ImVec4(0.8156862854957581, 0.772549033164978, 0.9647058844566345, 0.5490196347236633)
	style["Separator"] = ImVec4(0.6196078658103943, 0.5764706134796143, 0.7686274647712708, 0.5490196347236633)
	style["SeparatorHovered"] = ImVec4(0.7372549176216125, 0.6941176652908325, 0.886274516582489, 0.5490196347236633)
	style["SeparatorActive"] = ImVec4(0.8156862854957581, 0.772549033164978, 0.9647058844566345, 0.5490196347236633)
	style["ResizeGrip"] = ImVec4(0.6196078658103943, 0.5764706134796143, 0.7686274647712708, 0.5490196347236633)
	style["ResizeGripHovered"] = ImVec4(0.7372549176216125, 0.6941176652908325, 0.886274516582489, 0.5490196347236633)
	style["ResizeGripActive"] = ImVec4(0.8156862854957581, 0.772549033164978, 0.9647058844566345, 0.5490196347236633)
	style["Tab"] = ImVec4(0.6196078658103943, 0.5764706134796143, 0.7686274647712708, 0.5490196347236633)
	style["TabHovered"] = ImVec4(0.7372549176216125, 0.6941176652908325, 0.886274516582489, 0.5490196347236633)
	style["TabActive"] = ImVec4(0.8156862854957581, 0.772549033164978, 0.9647058844566345, 0.5490196347236633)
	style["TabUnfocused"] = ImVec4(0.0, 0.4509803950786591, 1.0, 0.0)
	style["TabUnfocusedActive"] = ImVec4(0.1333333402872086, 0.2588235437870026, 0.4235294163227081, 0.0)
	style["PlotLines"] = ImVec4(0.294117659330368, 0.294117659330368, 0.294117659330368, 1.0)
	style["PlotLinesHovered"] = ImVec4(0.7372549176216125, 0.6941176652908325, 0.886274516582489, 0.5490196347236633)
	style["PlotHistogram"] = ImVec4(0.6196078658103943, 0.5764706134796143, 0.7686274647712708, 0.5490196347236633)
	style["PlotHistogramHovered"] = ImVec4(0.7372549176216125, 0.6941176652908325, 0.886274516582489, 0.5490196347236633)
	style["TableHeaderBg"] = ImVec4(0.1882352977991104, 0.1882352977991104, 0.2000000029802322, 1.0)
	style["TableBorderStrong"] = ImVec4(0.4235294163227081, 0.3803921639919281, 0.572549045085907, 0.5490196347236633)
	style["TableBorderLight"] = ImVec4(0.4235294163227081, 0.3803921639919281, 0.572549045085907, 0.2918455004692078)
	style["TableRowBg"] = ImVec4(0.0, 0.0, 0.0, 0.0)
	style["TableRowBgAlt"] = ImVec4(1.0, 1.0, 1.0, 0.03433477878570557)
	style["TextSelectedBg"] = ImVec4(0.7372549176216125, 0.6941176652908325, 0.886274516582489, 0.5490196347236633)
	style["DragDropTarget"] = ImVec4(1.0, 1.0, 0.0, 0.8999999761581421)
	style["NavHighlight"] = ImVec4(0.0, 0.0, 0.0, 1.0)
	style["NavWindowingHighlight"] = ImVec4(1.0, 1.0, 1.0, 0.699999988079071)
	style["NavWindowingDimBg"] = ImVec4(0.800000011920929, 0.800000011920929, 0.800000011920929, 0.2000000029802322)
	style["ModalWindowDimBg"] = ImVec4(0.800000011920929, 0.800000011920929, 0.800000011920929, 0.3499999940395355)
	return style
end
