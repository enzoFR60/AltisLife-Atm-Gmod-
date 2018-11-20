include("shared.lua")

function ENT:Initialize()

end;

function ENT:Draw()
	self:DrawModel()

	local alpha = (LocalPlayer():GetPos():Distance(self:GetPos()) / 90)

	alpha = math.Clamp(1.75 - alpha, 0 ,1)

	local TIMER;
	local width = self:GetNWInt("width");
	if (self:GetNWInt("enzofr60_altislife_atm_hack_timer") < CurTime()) then
		TIMER = 0
	else 
		TIMER = self:GetNWInt("enzofr60_altislife_atm_hack_timer")-CurTime()
	end
	
	if self:GetPos():Distance(EyePos()) > 140 then return end
	
	local ang = self:GetAngles()
	local pos = self:GetPos()
	
	ang:RotateAroundAxis(self:GetAngles():Up(), 450)
	ang:RotateAroundAxis(self:GetAngles():Right(), 274)
	ang:RotateAroundAxis(self:GetAngles():Up(), 90)
	
	cam.Start3D2D(pos + ang:Up() * -3.0+ Vector( 0, 0, math.sin( CurTime() ) * 2 ), ang, 0.11)	
		if self:GetNWBool("hack") == true then
			draw.SimpleTextOutlined( "HACKED : "..string.ToMinutesSeconds(TIMER), "enzofr60_altislife_atm_Font_entity", -70, 10, Color(255,255,255,255* alpha), 0, 0, 1, Color(0,0,0,255* alpha) )
		else
			draw.SimpleTextOutlined( "ATM : 'E'", "enzofr60_altislife_atm_Font_entity", -40, 0, Color(255,255,255,255* alpha), 0, 0, 1, Color(0,0,0,255* alpha) )
			if self:GetNWEntity("Utilisateur") == NULL then
			else
				draw.SimpleTextOutlined( "Bonjour, "..self:GetNWEntity("Utilisateur"):Nick(), "enzofr60_altislife_atm_Font_entity", -90, 20, Color(255,255,255,255* alpha), 0, 0, 1, Color(0,0,0,255* alpha) )
			end
		end
	cam.End3D2D()

	cam.Start3D2D(pos + ang:Up() * -15.0+ ang:Forward() * -14.2 + ang:Right() * 27, ang, 0.11)
		if self:GetNWBool("hack") == true then
			draw.SimpleTextOutlined( "ERROR ...", "enzofr60_altislife_atm_info_Font_entity", 20, 30, Color(255,0,0,255* alpha), 0, 0, 1, Color(0,0,0,255* alpha) )
		else
			draw.SimpleText("Compte Bancaire :", "enzofr60_altislife_atm_infoname_Font_entity", 2, 0, Color(255,255,255,255* alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
			draw.SimpleText("Bonjour, "..LocalPlayer():Nick(), "enzofr60_altislife_atm_infoname_Font_entity", 2, 12, Color(255,255,255,255* alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

			surface.SetDrawColor( 255, 255, 255, 255* alpha ) 
			surface.SetMaterial( Material( "enzofr60_altislife_atm/icons/ico_bank.png" ) )
			surface.DrawTexturedRect( 0, 30, 16, 16 ) 

			local moneysursoncompte = LocalPlayer():GetAltisLifeMoneyATM() or 0

			draw.SimpleText(string.Comma(moneysursoncompte).."€", "enzofr60_altislife_atm_info_Font_entity", 20, 30, Color(255,255,255,255* alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

			surface.SetDrawColor( 255, 255, 255, 255* alpha ) 
			surface.SetMaterial( Material( "enzofr60_altislife_atm/icons/ico_money.png" ) )
			surface.DrawTexturedRect( 0, 50, 16, 16 ) 

			local moneysursois = LocalPlayer():getDarkRPVar("money") or 0

			draw.SimpleText(string.Comma(moneysursois).."€", "enzofr60_altislife_atm_info_Font_entity", 20, 50, Color(255,255,255,255* alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
	cam.End3D2D()
end;