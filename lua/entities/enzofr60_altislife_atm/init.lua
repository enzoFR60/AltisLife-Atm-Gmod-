AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/enzofr60_altislife_atm/models/enzofr60_altislife_atm.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
  
	if IsValid(phys) then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	local curTime = CurTime();
	if (!self.nextUse or curTime >= self.nextUse) then
		if not IsValid(self) then return end

		if self:GetNWBool("hack") == true then DarkRP.notify( caller, 1, 5, "L'atm se fait Hacker !" ) return end

		if not file.Exists("enzofr60/altislife/atm/banque/"..caller:SteamID64()..".txt", "DATA") then
			file.Write( "enzofr60/altislife/atm/banque/"..caller:SteamID64()..".txt", 0 )
		end
		
		if not file.Exists("enzofr60/altislife/atm/compte/"..caller:SteamID64()..".txt", "DATA") then
			file.Write( "enzofr60/altislife/atm/compte/"..caller:SteamID64()..".txt", caller:Nick() )
		end

		self:SetNWEntity("Utilisateur", caller)

		net.Start( "enzoFR60:AltisLife:Atm:System:OpenMenu" )
		net.WriteEntity(self)
		net.Send( caller )
		
		caller:MajAltisLifeMoneyATM()
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end