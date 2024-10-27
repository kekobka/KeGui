if SERVER then
	return
end
---@include panel.lua
require("panel.lua")
local render = render
local PANEL = {}
accessorFunc(PANEL, "used", "Used", false)
accessorFunc(PANEL, "FPS", "FPS", 24)

function PANEL:init()
	render.createRenderTarget(self.address)
	self.fps = 30
	self.fps_delta = 1 / 30
	self.next_frame = 0
	self.resW = 1024
	self.resH = 1024

	hook.add("renderoffscreen", self.address, function()
		if self.removed then
			hook.remove("renderoffscreen", self.address)
		else
			local now = timer.systime()
			if self.next_frame > now then
				return
			end
			self.next_frame = now + self.fps_delta
			render.selectRenderTarget(self.address)
			self:render(self.resW, self.resH)
			render.selectRenderTarget()
		end
	end)
end

function PANEL:paint(x, y, w, h)

	render.setRenderTargetTexture(self.address)
	render.setRGBA(255, 255, 255, 255)
	render.drawTexturedRect(x, y, w * (1024 / self.resW), h * (1024 / self.resH))

end

function PANEL:setFPS(fps)
	self.fps = fps
	self.fps_delta = 1 / fps
end

function PANEL:setRes(w, h)
	self.resW = w
	self.resH = h
end

function PANEL:render()
end

KeGui.register("Render", PANEL, "Panel")
