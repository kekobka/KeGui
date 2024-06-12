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

	style["Text"] = ImVec4(1.0, 1.0, 1.0, 1.0)
	style["TextDisabled"] = ImVec4(0.4980392158031464, 0.4980392158031464, 0.4980392158031464, 1.0)
	style["WindowBg"] = ImVec4(0.05882352963089943, 0.05882352963089943, 0.05882352963089943, 0.9399999976158142)
	style["ChildBg"] = ImVec4(0.0, 0.0, 0.0, 0.0)
	style["PopupBg"] = ImVec4(0.0784313753247261, 0.0784313753247261, 0.0784313753247261, 0.9399999976158142)
	style["Border"] = ImVec4(0.4274509847164154, 0.4274509847164154, 0.4980392158031464, 0.5)
	style["BorderShadow"] = ImVec4(0.0, 0.0, 0.0, 0.0)
	style["FrameBg"] = ImVec4(0.1568627506494522, 0.2862745225429535, 0.47843137383461, 0.5400000214576721)
	style["FrameBgHovered"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.4000000059604645)
	style["FrameBgActive"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.6700000166893005)
	style["TitleBg"] = ImVec4(0.03921568766236305, 0.03921568766236305, 0.03921568766236305, 1.0)
	style["TitleBgActive"] = ImVec4(0.1568627506494522, 0.2862745225429535, 0.47843137383461, 1.0)
	style["TitleBgCollapsed"] = ImVec4(0.0, 0.0, 0.0, 0.5099999904632568)
	style["MenuBarBg"] = ImVec4(0.1372549086809158, 0.1372549086809158, 0.1372549086809158, 1.0)
	style["ScrollbarBg"] = ImVec4(0.01960784383118153, 0.01960784383118153, 0.01960784383118153, 0.5299999713897705)
	style["ScrollbarGrab"] = ImVec4(0.3098039329051971, 0.3098039329051971, 0.3098039329051971, 1.0)
	style["ScrollbarGrabHovered"] = ImVec4(0.407843142747879, 0.407843142747879, 0.407843142747879, 1.0)
	style["ScrollbarGrabActive"] = ImVec4(0.5098039507865906, 0.5098039507865906, 0.5098039507865906, 1.0)
	style["CheckMark"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 1.0)
	style["SliderGrab"] = ImVec4(0.239215686917305, 0.5176470875740051, 0.8784313797950745, 1.0)
	style["SliderGrabActive"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 1.0)
	style["Button"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.4000000059604645)
	style["ButtonHovered"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 1.0)
	style["ButtonActive"] = ImVec4(0.05882352963089943, 0.529411792755127, 0.9764705896377563, 1.0)
	style["Header"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.3100000023841858)
	style["HeaderHovered"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.800000011920929)
	style["HeaderActive"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 1.0)
	style["Separator"] = ImVec4(0.4274509847164154, 0.4274509847164154, 0.4980392158031464, 0.5)
	style["SeparatorHovered"] = ImVec4(0.09803921729326248, 0.4000000059604645, 0.7490196228027344, 0.7799999713897705)
	style["SeparatorActive"] = ImVec4(0.09803921729326248, 0.4000000059604645, 0.7490196228027344, 1.0)
	style["ResizeGrip"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.2000000029802322)
	style["ResizeGripHovered"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.6700000166893005)
	style["ResizeGripActive"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.949999988079071)
	style["Tab"] = ImVec4(0.1764705926179886, 0.3490196168422699, 0.5764706134796143, 0.8619999885559082)
	style["TabHovered"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.800000011920929)
	style["TabActive"] = ImVec4(0.196078434586525, 0.407843142747879, 0.6784313917160034, 1.0)
	style["TabUnfocused"] = ImVec4(0.06666667014360428, 0.1019607856869698, 0.1450980454683304, 0.9724000096321106)
	style["TabUnfocusedActive"] = ImVec4(0.1333333402872086, 0.2588235437870026, 0.4235294163227081, 1.0)
	style["PlotLines"] = ImVec4(0.6078431606292725, 0.6078431606292725, 0.6078431606292725, 1.0)
	style["PlotLinesHovered"] = ImVec4(1.0, 0.4274509847164154, 0.3490196168422699, 1.0)
	style["PlotHistogram"] = ImVec4(0.8980392217636108, 0.6980392336845398, 0.0, 1.0)
	style["PlotHistogramHovered"] = ImVec4(1.0, 0.6000000238418579, 0.0, 1.0)
	style["TableHeaderBg"] = ImVec4(0.1882352977991104, 0.1882352977991104, 0.2000000029802322, 1.0)
	style["TableBorderStrong"] = ImVec4(0.3098039329051971, 0.3098039329051971, 0.3490196168422699, 1.0)
	style["TableBorderLight"] = ImVec4(0.2274509817361832, 0.2274509817361832, 0.2470588237047195, 1.0)
	style["TableRowBg"] = ImVec4(0.0, 0.0, 0.0, 0.0)
	style["TableRowBgAlt"] = ImVec4(1.0, 1.0, 1.0, 0.05999999865889549)
	style["TextSelectedBg"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 0.3499999940395355)
	style["DragDropTarget"] = ImVec4(1.0, 1.0, 0.0, 0.8999999761581421)
	style["NavHighlight"] = ImVec4(0.2588235437870026, 0.5882353186607361, 0.9764705896377563, 1.0)
	style["NavWindowingHighlight"] = ImVec4(1.0, 1.0, 1.0, 0.699999988079071)
	style["NavWindowingDimBg"] = ImVec4(0.800000011920929, 0.800000011920929, 0.800000011920929, 0.2000000029802322)
	style["ModalWindowDimBg"] = ImVec4(0.800000011920929, 0.800000011920929, 0.800000011920929, 0.3499999940395355)

	return style
end
