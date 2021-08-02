include("shared.lua")

function ENT:Draw()

	self:DrawModel()

end

surface.CreateFont( "MenuFont", {
	font = "Agency FB",
	size = 30,
	weight = 500,
} )

function ToggleTPMenu()
		local scrw, scrh = ScrW(), ScrH()
		if IsValid(TPMenu) then
			TPMenu:Remove()
		end
		TPMenu = vgui.Create("DFrame")
		TPMenu:SetTitle("")
		TPMenu:SetSize(scrw * .25, scrh * .5)
		TPMenu:Center()
		TPMenu:MakePopup()
		TPMenu:ShowCloseButton(true)
		TPMenu:SetDraggable(true)
		TPMenu.Paint = function(self,w,h)
			surface.SetDrawColor(82,182,154, 220)
			surface.DrawRect(0,0,w,h)
			draw.SimpleText("Teleport Ticket", "MenuFont", w / 2, h * 0.025, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		local ypos = 0
		local scroll = vgui.Create("DScrollPanel", TPMenu)
		scroll:SetSize(TPMenu:GetWide(), TPMenu:GetTall() * .90)
		scroll:SetPos(0, TPMenu:GetTall() * .06)
		--for k, v in ipairs(Destinations) do
			--local locationPanel = vgui.Create("DPanel", TPMenu)
			--locationPanel:SetPos(0, ypos)
			--locationPanel:SetSize(TPMenu:GetWide(), TPMenu:GetTall() * .07)
			--locationPanel.Paint = function(self,w,h)
				--surface.SetDrawColor(0,0,0,200)
				--surface.DrawRect(0,0,w,h)
				--draw.SimpleText(v.name, "MenuFont", w / 2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			--end
			--ypos = ypos + locationPanel:GetTall() * 1.1
		--end
		for k,v in ipairs(Destinations) do
			local locationButton = vgui.Create("DButton", scroll)
			locationButton:SetPos(TPMenu:GetWide() / 7.5, ypos)
			locationButton:SetSize(TPMenu:GetWide()*.75, TPMenu:GetTall()*0.07)
			locationButton:SetText("")
			locationButton.Paint = function(self,w,h)
				surface.SetDrawColor(0,0,0,220)
				surface.DrawRect(0,0,w,h)
				draw.SimpleText(v.name, "MenuFont", w * .5, h * .5, Color(52,160,164), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			ypos = ypos + locationButton:GetTall() * 1.1
			locationButton.DoClick = function()
				TPMenu:Remove()
				net.Start("TPInfo")
				net.WriteEntity(LocalPlayer())
				net.WriteVector(v.pos)
				net.WriteAngle(v.angle)
				net.SendToServer()
			end
		end
end


net.Receive("useMenu", function()

	ToggleTPMenu()

end)