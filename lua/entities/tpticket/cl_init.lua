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
		TPMenu:SetDraggable(false)
		TPMenu.Paint = function(self,w,h)
			surface.SetDrawColor(82,182,154, 220)
			surface.DrawRect(0,0,w,h)
			draw.SimpleText("Teleport Ticket", "MenuFont", w / 2, h * 0.025, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		function TPMenu:OnClose()
			net.Start("NPlayerUsing")
			net.SendToServer()
		end
		local ypos = 0
		local scroll = vgui.Create("DScrollPanel", TPMenu)
		scroll:SetSize(TPMenu:GetWide(), TPMenu:GetTall() * .90)
		scroll:SetPos(0, TPMenu:GetTall() * .06)
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
				net.WriteTable(v)
				net.SendToServer()
			end
		end
end

net.Receive("useMenu", function()
	ToggleTPMenu()
end)