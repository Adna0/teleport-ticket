AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("useMenu")
util.AddNetworkString("TPInfo")
util.AddNetworkString("NPlayerUsing")
function ENT:Initialize()

	self:SetModel("models/props_lab/clipboard.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()

	if phys:IsValid() then

		phys:Wake()

	end
	function removeEntity()
		self:Remove()
	end

	net.Receive("NPlayerUsing", function()
		self:SetPlayerUsing(false)
	end)

	net.Receive("TPInfo", function()
		local ply = net.ReadEntity()
		local pos = net.ReadVector()
		local angle = net.ReadAngle()
		ply:Freeze(true)
		ply:ScreenFade(SCREENFADE.OUT, color_black, 2, 1)
		timer.Simple(2, function()
			ply:Freeze(false)
			ply:ScreenFade(SCREENFADE.IN, color_black, 2, 1)
			ply:SetPos(pos)
			ply:SetEyeAngles(angle)
		end)
		self:Remove()
	end)
end

function ENT:Use(ply, caller)
	if self:GetPlayerUsing() != true then
		net.Start("useMenu")
		net.Send(ply)
		self:SetPlayerUsing(true)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "PlayerUsing")
end