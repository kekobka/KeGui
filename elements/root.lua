---@include panel.lua
require("panel.lua")
local PANEL = {}

function PANEL:paint(x, y, w, h)
end

KeGui.register("Root", PANEL, "Panel")
