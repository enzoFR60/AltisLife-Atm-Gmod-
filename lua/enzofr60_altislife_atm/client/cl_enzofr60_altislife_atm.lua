if not CLIENT then return end

surface.CreateFont("enzofr60_altislife_atm_Font", {
  font = "Roboto",
  size =  ScrH()*0.03,
  weight = 1000,
  antialias = true
})

surface.CreateFont("enzofr60_altislife_atm_Montant_Font", {
  font = "Roboto",
  size =  ScrH()*0.024,
  weight = 1000,
  antialias = true
})

surface.CreateFont("enzofr60_altislife_atm_Font_entity", {
  font = "Roboto",
  size =  24,
  weight = 1000,
  antialias = true
})

surface.CreateFont("enzofr60_altislife_atm_info_Font_entity", {
  font = "Roboto",
  size =  12,
  weight = 1000,
  antialias = true
})

surface.CreateFont("enzofr60_altislife_atm_infoname_Font_entity", {
  font = "Roboto",
  size =  8,
  weight = 1000,
  antialias = true
})


local blur = Material("pp/blurscreen")
local function DrawBlur( p, a, d )
	local x, y = p:LocalToScreen( 0, 0 )
	
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	
	for i = 1, d do
		blur:SetFloat( "$blur", (i / d ) * ( a ) )
		blur:Recompute()
		
		render.UpdateScreenEffectTexture()
		
		surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
	end
end

local meta = FindMetaTable("Player")

function meta:GetAltisLifeMoneyATM()

  return self:GetNWInt("enzoFR60:AltisLife:Atm:System:CompteMaj")

end

net.Receive("enzoFR60:AltisLife:Atm:System:CompteMaj", function()
	local solde = net.ReadInt(32) or 0
	LocalPlayer():SetNWInt("enzoFR60:AltisLife:Atm:System:CompteMaj",solde)
end)

net.Receive( "enzoFR60:AltisLife:Atm:System:OpenMenu", function()

	local scrw, scrh = ScrW(), ScrH()

	local atmentity = net.ReadEntity()

	local function inQuad( fraction, beginning, change )
		return change * ( fraction ^ 2 ) + beginning
	end

	local DFrame1 = vgui.Create("DFrame")
	DFrame1:SetSize(scrw*.3, scrh*.42)
	DFrame1:SetTitle("Bank Account Management")
	DFrame1:SetDraggable(true)
	DFrame1:ShowCloseButton(false)
	DFrame1:MakePopup()

	local anim = Derma_Anim( "EaseInQuad", DFrame1, function( pnl, anim, delta, data )
		pnl:SetPos( inQuad( delta, scrw*0.1-2000, scrw*0.01+2350 ), scrh*0.22 )
	end )
	anim:Start( 0.4 )
	DFrame1.Think = function( self )
		if anim:Active() then
			anim:Run()
		end
	end

	DFrame1.Paint = function(self, w, h)
	end

	local enzofr60_altislife_atm_frametime = 0

	local DPanel2 = vgui.Create( "DPanel", DFrame1 )
	DPanel2:SetSize(scrw*.3, scrh*.4)
	DPanel2:SetPos( scrw*.0, scrh*.04 )
	DPanel2.Paint = function(p, w, h)
		DrawBlur( p, 6, 30 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 120 ) )

		surface.SetDrawColor( 255, 255, 255, 255 ) 
		surface.SetMaterial( Material( "enzofr60_altislife_atm/icons/ico_bank.png" ) )
		surface.DrawTexturedRect( scrw*.06, scrh*.01, scrw*.035, scrh*.06 ) 

		surface.SetDrawColor( 255, 255, 255, 255 ) 
		surface.SetMaterial( Material( "enzofr60_altislife_atm/icons/ico_money.png" ) )
		surface.DrawTexturedRect( scrw*.06, scrh*.08, scrw*.035, scrh*.04 ) 
	end

	local DPanel = vgui.Create( "DPanel", DFrame1 )
	DPanel:SetSize(scrw*.3, scrh*.42)
	DPanel:Center()
	DPanel.Paint = function(p, w, h)
		draw.RoundedBox( 0, 0, 0, w, scrh*.03, Color( 255, 187, 17, 120 ) )
	end

	argentbank = vgui.Create( "DLabel", DFrame1 )
	argentbank:SetSize( scrw*.2, scrh*.08 )
	argentbank:SetPos( scrw*.1, scrh*.05 )
	argentbank:SetTextColor(Color(255,255,255))
	argentbank:SetVisible(true)
	argentbank:SetFont("enzofr60_altislife_atm_Font")
	argentbank:SetText(string.Comma(LocalPlayer():GetAltisLifeMoneyATM()).."€")

	local moneysursois = LocalPlayer():getDarkRPVar("money") or 0

	argentsursois = vgui.Create( "DLabel", DFrame1 )
	argentsursois:SetSize( scrw*.2, scrh*.08 )
	argentsursois:SetPos( scrw*.1, scrh*.1 )
	argentsursois:SetTextColor(Color(255,255,255))
	argentsursois:SetVisible(true)
	argentsursois:SetFont("enzofr60_altislife_atm_Font")
	argentsursois:SetText(string.Comma(moneysursois).."€")

	money = vgui.Create("DTextEntry", DFrame1)
	money:SetText("Montant ?")
	money:SetNumeric( true )
	money:SetSize( scrw*.2, scrh*.05 )
	money:SetPos( scrw*.05, scrh*.17 )
	money:SetTextColor( Color( 255, 255, 255 ) )
	money.Paint = function( self, w, h )
		surface.SetDrawColor(0, 0, 0, 120)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end

	local DButton1 = vgui.Create( "DButton", DFrame1 )
	DButton1:SetSize( scrw*.05, scrh*.02 )
	DButton1:SetPos( scrw*.17, scrh*.01-03 )
	DButton1:SetText("Hack")
	DButton1:SetTextColor( Color( 255, 255, 255 ) )
	DButton1.Paint = function(p, w, h)
		draw.RoundedBox( 6, 0, 0, w, h, Color( 30, 30, 30, 120 ) )
		local flashing = 100 + math.abs( math.sin( CurTime() * 1.1 ) * 255 )
		surface.SetDrawColor( flashing, flashing, flashing, flashing )
		surface.DrawOutlinedRect( 0, 0, p:GetWide(), p:GetTall() ) 
	end
	DButton1.DoClick = function( pnl )
		net.Start( "enzoFR60:AltisLife:Atm:System:Fermer" )
		net.WriteEntity(atmentity)
		net.SendToServer()
		net.Start( "enzoFR60:AltisLife:Atm:System:Hack" )
		net.WriteEntity(atmentity)
		net.SendToServer()
		DFrame1:Close()
	end

	local close = vgui.Create( "DButton", DFrame1 )
	close:SetSize( scrw*.05, scrh*.02 )
	close:SetPos( scrw*.24, scrh*.01-03 )
	close:SetText("Fermer")
	close:SetTextColor( Color( 255, 255, 255 ) )
	close.Paint = function(p, w, h)
		draw.RoundedBox( 6, 0, 0, w, h, Color( 30, 30, 30, 120 ) )
		local flashing = 100 + math.abs( math.sin( CurTime() * 1.1 ) * 255 )
		surface.SetDrawColor( flashing, flashing, flashing, flashing )
		surface.DrawOutlinedRect( 0, 0, p:GetWide(), p:GetTall() ) 
	end
	close.DoClick = function( pnl )
		net.Start( "enzoFR60:AltisLife:Atm:System:Fermer" )
		net.WriteEntity(atmentity)
		net.SendToServer()
		DFrame1:Close()	
	end

	local DButton1 = vgui.Create( "DButton", DFrame1 )
	DButton1:SetSize( scrw*.2, scrh*.04 )
	DButton1:SetPos( scrw*.05, scrh*.28 )
	DButton1:SetText("Deposer")
	DButton1:SetTextColor( Color( 255, 255, 255 ) )
	DButton1.Paint = function(p, w, h)
		draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 187, 17, 20 ) )
		local flashing = 100 + math.abs( math.sin( CurTime() * 1.1 ) * 255 )
		surface.SetDrawColor( flashing, flashing, flashing, flashing )
		surface.DrawOutlinedRect( 0, 0, p:GetWide(), p:GetTall() ) 
	end
	DButton1.DoClick = function( pnl )
		if money:GetValue() == "" || money:GetValue() == "Montant ?" then return end
		net.Start( "enzoFR60:AltisLife:Atm:System:Fermer" )
		net.WriteEntity(atmentity)
		net.SendToServer()
		net.Start( "enzoFR60:AltisLife:Atm:System:Deposer" )
		net.WriteInt(tonumber(money:GetValue()),32)
		net.SendToServer()
		DFrame1:Close()	
	end

	local DButton11 = vgui.Create( "DButton", DFrame1 )
	DButton11:SetSize( scrw*.2, scrh*.04 )
	DButton11:SetPos( scrw*.05, scrh*.23 )
	DButton11:SetText("Retirer")
	DButton11:SetTextColor( Color( 255, 255, 255 ) )
	DButton11.Paint = function(p, w, h)
		draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 187, 17, 20 ) )
		local flashing = 100 + math.abs( math.sin( CurTime() * 1.1 ) * 255 )
		surface.SetDrawColor( flashing, flashing, flashing, flashing )
		surface.DrawOutlinedRect( 0, 0, p:GetWide(), p:GetTall() ) 
	end
	DButton11.DoClick = function( pnl )
		if money:GetValue() == "" || money:GetValue() == "Montant ?" then return end
		net.Start( "enzoFR60:AltisLife:Atm:System:Fermer" )
		net.WriteEntity(atmentity)
		net.SendToServer()
		net.Start( "enzoFR60:AltisLife:Atm:System:Retirer" )
		net.WriteEntity(atmentity)
		net.WriteInt(tonumber(money:GetValue()),32)
		net.SendToServer()
		DFrame1:Close()
	end

	local DButton11 = vgui.Create( "DButton", DFrame1 )
	DButton11:SetSize( scrw*.2, scrh*.04 )
	DButton11:SetPos( scrw*.05, scrh*.37 )
	DButton11:SetText("Transferer")
	DButton11:SetTextColor( Color( 255, 255, 255 ) )
	DButton11.Paint = function(p, w, h)
		draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 187, 17, 20 ) )
		local flashing = 100 + math.abs( math.sin( CurTime() * 1.1 ) * 255 )
		surface.SetDrawColor( flashing, flashing, flashing, flashing )
		surface.DrawOutlinedRect( 0, 0, p:GetWide(), p:GetTall() ) 
	end
	DButton11.DoClick = function( pnl )
		if money:GetValue() == "" || money:GetValue() == "Montant ?" then return end
		if DComboBox:GetText() == "" || DComboBox:GetText() == "Choisir un joueur" then return end
		net.Start( "enzoFR60:AltisLife:Atm:System:Fermer" )
		net.WriteEntity(atmentity)
		net.SendToServer()
		net.Start( "enzoFR60:AltisLife:Atm:System:Transferer" )
		net.WriteInt(tonumber(money:GetValue()),32)
		net.WriteString(DComboBox:GetText())
		net.SendToServer()
		DFrame1:Close()
	end

	DComboBox = vgui.Create( "DComboBox", DFrame1 )
	DComboBox:SetSize( scrw*.2, scrh*.04 )
	DComboBox:SetPos( scrw*.05, scrh*.325 )
	DComboBox:SetValue( "Choisir un joueur" )
	DComboBox:SetTextColor( Color( 255, 255, 255 ) )
	DComboBox.Paint = function(p, w, h)
		draw.RoundedBox( 6, 0, 0, w, h, Color( 30, 30, 30, 80 ) )
		surface.SetDrawColor( 255, 187, 17, 20 )
		surface.DrawOutlinedRect( 0, 0, p:GetWide(), p:GetTall() )
	end
	for k,v in pairs(player.GetAll()) do
		DComboBox:AddChoice( v:Nick() )
	end
end)

net.Receive( "enzoFR60:AltisLife:Atm:System:Card:OpenMenu", function()

	local scrw, scrh = ScrW(), ScrH()

	local atmentity = net.ReadEntity()

	local owneratmentity = net.ReadEntity()

	local function inQuad( fraction, beginning, change )
		return change * ( fraction ^ 2 ) + beginning
	end

	local DFrame1 = vgui.Create("DFrame")
	DFrame1:SetSize(scrw*.3, scrh*.42)
	DFrame1:SetTitle("Machine à Carte - "..owneratmentity:Nick())
	DFrame1:SetDraggable(true)
	DFrame1:ShowCloseButton(false)
	DFrame1:MakePopup()

	local anim = Derma_Anim( "EaseInQuad", DFrame1, function( pnl, anim, delta, data )
		pnl:SetPos( inQuad( delta, scrw*0.1-2000, scrw*0.01+2350 ), scrh*0.22 )
	end )
	anim:Start( 0.4 )
	DFrame1.Think = function( self )
		if anim:Active() then
			anim:Run()
		end
	end

	DFrame1.Paint = function(self, w, h)
	end

	local DPanel2 = vgui.Create( "DPanel", DFrame1 )
	DPanel2:SetSize(scrw*.3, scrh*.4)
	DPanel2:SetPos( scrw*.0, scrh*.04 )
	DPanel2.Paint = function(p, w, h)
		DrawBlur( p, 6, 30 )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 120 ) )

		surface.SetDrawColor( 255, 255, 255, 255 ) 
		surface.SetMaterial( Material( "enzofr60_altislife_atm/icons/ico_money.png" ) )
		surface.DrawTexturedRect( scrw*.06, scrh*.04, scrw*.035, scrh*.04 ) 
	end

	local DPanel = vgui.Create( "DPanel", DFrame1 )
	DPanel:SetSize(scrw*.3, scrh*.42)
	DPanel:Center()
	DPanel.Paint = function(p, w, h)
		draw.RoundedBox( 0, 0, 0, w, scrh*.03, Color( 255, 187, 17, 120 ) )
	end

	montantcard = vgui.Create( "DLabel", DFrame1 )
	montantcard:SetSize( scrw*.2, scrh*.08 )
	montantcard:SetPos( scrw*.1, scrh*.06 )
	montantcard:SetTextColor(Color(255,255,255))
	montantcard:SetVisible(true)
	montantcard:SetFont("enzofr60_altislife_atm_Montant_Font")
	montantcard:SetText("Montant de la facture : "..string.Comma(atmentity:GetNWInt("montant")).."€")

	local close = vgui.Create( "DButton", DFrame1 )
	close:SetSize( scrw*.05, scrh*.02 )
	close:SetPos( scrw*.24, scrh*.01-03 )
	close:SetText("Fermer")
	close:SetTextColor( Color( 255, 255, 255 ) )
	close.Paint = function(p, w, h)
		draw.RoundedBox( 6, 0, 0, w, h, Color( 30, 30, 30, 120 ) )
		local flashing = 100 + math.abs( math.sin( CurTime() * 1.1 ) * 255 )
		surface.SetDrawColor( flashing, flashing, flashing, flashing )
		surface.DrawOutlinedRect( 0, 0, p:GetWide(), p:GetTall() ) 
	end
	close.DoClick = function( pnl )
		DFrame1:Close()	
	end

	money = vgui.Create("DTextEntry", DFrame1)
	money:SetText("Montant ?")
	money:SetNumeric( true )
	money:SetSize( scrw*.2, scrh*.05 )
	money:SetPos( scrw*.05, scrh*.17 )
	money:SetTextColor( Color( 255, 255, 255 ) )
	money.Paint = function( self, w, h )
		surface.SetDrawColor(0, 0, 0, 120)
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
		self:DrawTextEntryText(Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255))
	end

	if owneratmentity == LocalPlayer() then

		local DButton1 = vgui.Create( "DButton", DFrame1 )
		DButton1:SetSize( scrw*.2, scrh*.04 )
		DButton1:SetPos( scrw*.05, scrh*.28 )
		DButton1:SetText("Modifier le montant")
		DButton1:SetTextColor( Color( 255, 255, 255 ) )
		DButton1.Paint = function(p, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 187, 17, 20 ) )
			local flashing = 100 + math.abs( math.sin( CurTime() * 1.1 ) * 255 )
			surface.SetDrawColor( flashing, flashing, flashing, flashing )
			surface.DrawOutlinedRect( 0, 0, p:GetWide(), p:GetTall() ) 
		end
		DButton1.DoClick = function( pnl )
			if money:GetValue() == "" || money:GetValue() == "Montant ?" then return end
			net.Start( "enzoFR60:AltisLife:Atm:System:Card:ChangeMontant" )
			net.WriteEntity(atmentity)
			net.WriteInt(tonumber(money:GetValue()),32)
			net.SendToServer()
			DFrame1:Close()	
		end
	else

		money:SetEditable( false )

		local DButton1 = vgui.Create( "DButton", DFrame1 )
		DButton1:SetSize( scrw*.2, scrh*.04 )
		DButton1:SetPos( scrw*.05, scrh*.28 )
		DButton1:SetText("Payer")
		DButton1:SetTextColor( Color( 255, 255, 255 ) )
		DButton1.Paint = function(p, w, h)
			draw.RoundedBox( 6, 0, 0, w, h, Color( 255, 187, 17, 20 ) )
			local flashing = 100 + math.abs( math.sin( CurTime() * 1.1 ) * 255 )
			surface.SetDrawColor( flashing, flashing, flashing, flashing )
			surface.DrawOutlinedRect( 0, 0, p:GetWide(), p:GetTall() ) 
		end
		DButton1.DoClick = function( pnl )
			if atmentity:GetNWInt("montant") == 0 || atmentity:GetNWInt("montant") == "0" then return end
			net.Start( "enzoFR60:AltisLife:Atm:System:Card:Payer" )
			net.WriteEntity(atmentity)
			net.WriteInt(tonumber(atmentity:GetNWInt("montant")),32)
			net.SendToServer()
			DFrame1:Close()	
		end
	end
end)

