include("shared.lua")

function ENT:Initialize()

end;

function ENT:Draw()
	self:DrawModel()

	local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 90)

	alpha = math.Clamp(1.75 - alpha, 0 ,1)

	self:DrawModel()
	
	if self:GetPos():Distance(EyePos()) > 140 then return end
	
	local ang = self:GetAngles()
	local pos = self:GetPos()
	local spin = CurTime() * 180
	
	ang:RotateAroundAxis(self:GetAngles():Up(), 450)
	ang:RotateAroundAxis(self:GetAngles():Right(), 274)
	ang:RotateAroundAxis(self:GetAngles():Up(), 90)
	
	cam.Start3D2D(pos + ang:Up() * -3.0+ Vector( 0, 0, math.sin( CurTime() ) * 2 ), ang, 0.11)	
		draw.SimpleTextOutlined( "Machine à carte : 'E'", "enzofr60_altislife_atm_Font_entity", -70, -97, Color(255,255,255,255* alpha), 0, 0, 1, Color(0,0,0,255* alpha) )
	if self:GetNWEntity("owner") == NULL then
	else
		draw.SimpleTextOutlined( self:GetNWEntity("owner"):Nick(), "enzofr60_altislife_atm_Font_entity", -70, -75, Color(255,255,255,255* alpha), 0, 0, 1, Color(0,0,0,255* alpha) )
	end
	cam.End3D2D()

end;