if not SERVER then return end

-- Meta

local meta = FindMetaTable("Player")

function meta:SetAltisLifeMoneyATM(price)

  if file.Exists("enzofr60/altislife/atm/banque/" .. self:SteamID64() .. ".txt","DATA") then

    file.Write("enzofr60/altislife/atm/banque/" .. self:SteamID64() .. ".txt",price)

  end

end

function meta:GetAltisLifeMoneyATM()

  if file.Exists("enzofr60/altislife/atm/banque/" .. self:SteamID64() .. ".txt","DATA") then

    return tonumber(file.Read("enzofr60/altislife/atm/banque/" .. self:SteamID64() .. ".txt","DATA"))

  end

end

function meta:MajAltisLifeMoneyATM()

  if file.Exists("enzofr60/altislife/atm/banque/" .. self:SteamID64() .. ".txt","DATA") then
	  	net.Start("enzoFR60:AltisLife:Atm:System:CompteMaj")
		net.WriteInt(self:GetAltisLifeMoneyATM(),32)
		net.Send(self)
    return
  end

end

-- Data/Hook

function create_enzofr60_altislife_atm_init()
	if not file.Exists("enzofr60/altislife/atm", "DATA") then
		file.CreateDir( "enzofr60/altislife/atm", "DATA" )
	end
	
	if not file.Exists("enzofr60/altislife/atm/compte", "DATA") then
		file.CreateDir( "enzofr60/altislife/atm/compte", "DATA" )
	end
	
	if not file.Exists("enzofr60/altislife/atm/banque", "DATA") then
		file.CreateDir( "enzofr60/altislife/atm/banque", "DATA" )
	end
end
hook.Add( "Initialize", "create_enzofr60_altislife_atm_init", create_enzofr60_altislife_atm_init )

hook.Add( "PlayerInitialSpawn", "enzofr60_altislife_atm_ctc", function(ply)
	create_enzofr60_altislife_atm_init()
	
	if not file.Exists("enzofr60/altislife/atm/banque/"..ply:SteamID64()..".txt", "DATA") then
		file.Write( "enzofr60/altislife/atm/banque/"..ply:SteamID64()..".txt", 0 )
	end

	if not file.Exists("enzofr60/altislife/atm/compte/"..ply:SteamID64()..".txt", "DATA") then
		file.Write( "enzofr60/altislife/atm/compte/"..ply:SteamID64()..".txt", ply:Nick() )
	end
end)

-- AddNetworkString

util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:OpenMenu" )

util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:Fermer" )

util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:Card:OpenMenu" )

util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:Card:ChangeMontant" )

util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:Card:Payer" )

util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:CompteMaj" )

util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:Deposer" )
util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:Retirer" )
util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:Transferer" )

util.AddNetworkString( "enzoFR60:AltisLife:Atm:System:Hack" )

-- Net Receive

net.Receive( "enzoFR60:AltisLife:Atm:System:Fermer", function(len, caller)
	if not IsValid(caller) and not caller:IsPlayer() then return end
	local atmentity = net.ReadEntity()
	if not IsValid(atmentity) then return end

	atmentity:SetNWEntity("Utilisateur", NULL)
end)

net.Receive( "enzoFR60:AltisLife:Atm:System:Deposer", function(len, caller)
	if not IsValid(caller) and not caller:IsPlayer() then return end
	local demande = net.ReadInt(32)
	local solde = caller:GetAltisLifeMoneyATM()
	local newsolde = solde+demande
	if demande > enzoFR60.AltisLife.Atm.System.Config.MontantMaxAtm then DarkRP.notify( caller, 1, 5, "Tu peut pas mettre un montant aussi grand (ATM) !" ) return end
	if caller:canAfford(demande) then
		caller:addMoney(-demande)
		DarkRP.notify( caller, 0, 5, "Tu vient de deposé "..string.Comma(demande).."€" )
		caller:SetAltisLifeMoneyATM(newsolde)
		caller:MajAltisLifeMoneyATM()
	else
		DarkRP.notify( caller, 1, 5, "Vous n'avez pas assez pour déposer "..string.Comma(demande).."€" )
	end
end)

net.Receive( "enzoFR60:AltisLife:Atm:System:Retirer", function(len, caller)
	local atmentity = net.ReadEntity()
	local demande = net.ReadInt(32)
	if not IsValid(atmentity) then return end
	if demande > enzoFR60.AltisLife.Atm.System.Config.MontantMaxAtm then DarkRP.notify( caller, 1, 5, "Tu peut pas mettre un montant aussi grand (ATM) !" ) return end
	local solde = caller:GetAltisLifeMoneyATM()
	if solde < demande then
		DarkRP.notify( caller, 1, 5, "Vous n'avez pas assez pour retirer "..string.Comma(demande).."€" )
	else
		local money = ents.Create("enzofr60_altislife_atm_money")
		if not IsValid(money) then return end
	    money:SetPos( atmentity:GetPos()+Vector(atmentity:GetUp()*-40)+(atmentity:GetForward()*-8)+(atmentity:GetRight()*1) )
	    money:Spawn()
	    DarkRP.notify( caller, 0, 5, "Tu vient de retiré "..string.Comma(demande).."€" )
	    local newsolde = tonumber(solde)-demande
		caller:addMoney(demande)
		caller:SetAltisLifeMoneyATM(newsolde)
		caller:MajAltisLifeMoneyATM()
		timer.Simple(1,function()
			money:Remove()
		end)
	end
end)

net.Receive( "enzoFR60:AltisLife:Atm:System:Transferer", function(len, caller)
	local demande = net.ReadInt(32)
	local playertransf = net.ReadString()

	if demande > enzoFR60.AltisLife.Atm.System.Config.MontantMaxAtm then DarkRP.notify( caller, 1, 5, "Tu peut pas mettre un montant aussi grand (ATM) !" ) return end

	for k,v in pairs(player.GetAll()) do
		if v:Nick() == playertransf then
			if v == caller then DarkRP.notify( caller, 1, 5, "Une erreur est survenue!" ) return end
			playertransferok = v
		end
	end

	local solde = caller:GetAltisLifeMoneyATM()

	local soldetransf = playertransferok:GetAltisLifeMoneyATM()
	
	if solde < demande then
		DarkRP.notify( caller, 1, 5, "Vous n'avez pas assez pour faire un transfer de "..string.Comma(demande).."€" )
	else
		if not IsValid(playertransferok) then DarkRP.notify( caller, 1, 5, "Une erreur est survenue!" ) return end
		local newsolde = tonumber(solde)-demande

		local newsoldetransf = tonumber(soldetransf)+demande

		-- caller
		
		DarkRP.notify( caller, 0, 5, "Tu vient de transferer "..string.Comma(demande).."€ à "..playertransf )
		
		caller:SetAltisLifeMoneyATM(newsolde)

		caller:MajAltisLifeMoneyATM()

		-- player tranfer

		DarkRP.notify( playertransferok, 0, 5, "Tu a reçu un transfer de "..string.Comma(demande).."€")

		playertransferok:SetAltisLifeMoneyATM(newsoldetransf)

		playertransferok:MajAltisLifeMoneyATM()
	end
end)

net.Receive( "enzoFR60:AltisLife:Atm:System:Hack", function(len, caller)
	if not IsValid(caller) and not caller:IsPlayer() then return end
	local atmentity = net.ReadEntity()
	if not IsValid(atmentity) then return end

	if enzoFR60.AltisLife.Atm.System.Config.Hack == false then DarkRP.notify( caller, 1, 5, "Une Erreur est survenue !" ) return end
	if atmentity:GetNWBool("hack") == true then DarkRP.notify( caller, 1, 5, "Une Erreur est survenue !" ) return end

	atmentity:SetNWBool("hack", true)
	DarkRP.notify( caller, 0, 5, "Le hack a commencer !" )

	local timeforhack = math.random(enzoFR60.AltisLife.Atm.System.Config.MinTimerForHack,enzoFR60.AltisLife.Atm.System.Config.MaxTimerForHack)
	atmentity:SetNWInt("enzofr60_altislife_atm_hack_timer", timeforhack+CurTime())

	timer.Simple(timeforhack, function()
		if not IsValid(atmentity) then return end
		if not IsValid(caller) and not caller:IsPlayer() then return end
		if caller:GetPos():Distance(atmentity:GetPos()) > 140 then
			DarkRP.notify( caller, 1, 5, "Tu est partit trop loin !" )
			atmentity:SetNWBool("hack", false)
			atmentity:SetNWInt("enzofr60_altislife_atm_hack_timer", 0)
			return
		end

		local montantmoneyhack = math.random(enzoFR60.AltisLife.Atm.System.Config.MinWinMoneyForHack,enzoFR60.AltisLife.Atm.System.Config.MaxWinMoneyForHack)

		DarkRP.notify( caller, 0, 5, "Tu a reçu "..string.Comma(montantmoneyhack).."€ pour le hack de l'atm!" )
		atmentity:SetNWBool("hack", false)
		atmentity:SetNWInt("enzofr60_altislife_atm_hack_timer", 0)
		caller:addMoney(montantmoneyhack)
	end)
end)

net.Receive( "enzoFR60:AltisLife:Atm:System:Card:ChangeMontant", function(len, caller)
	if not IsValid(caller) and not caller:IsPlayer() then return end
	local atmentity = net.ReadEntity()
	local demande = net.ReadInt(32)
	if not IsValid(atmentity) then return end

	if demande > enzoFR60.AltisLife.Atm.System.Config.MontantMaxAtm then DarkRP.notify( caller, 1, 5, "Tu peut pas mettre un montant aussi grand (Machine a carte) !" ) return end

	atmentity:SetNWInt("montant", demande)
	DarkRP.notify( caller, 0, 5, "Tu vien de changer le montant de la facture à "..string.Comma(demande).."€ (Machine a carte) !" )
end)

net.Receive( "enzoFR60:AltisLife:Atm:System:Card:Payer", function(len, caller)
	local atmentity = net.ReadEntity()
	local demande = net.ReadInt(32)

	local solde = caller:GetAltisLifeMoneyATM()

	local soldetransf = atmentity:GetNWEntity("owner"):GetAltisLifeMoneyATM()
	
	if solde < demande then
		DarkRP.notify( caller, 1, 5, "Vous n'avez pas assez pour faire un transfer de "..string.Comma(demande).."€" )
	else
		if not IsValid(atmentity:GetNWEntity("owner")) then DarkRP.notify( caller, 1, 5, "Une erreur est survenue!" ) return end
		local newsolde = tonumber(solde)-demande

		local newsoldetransf = tonumber(soldetransf)+demande

		-- caller
		
		DarkRP.notify( caller, 0, 5, "Tu vient de transferer "..string.Comma(demande).."€ à "..atmentity:GetNWEntity("owner"):Nick() )
		
		caller:SetAltisLifeMoneyATM(newsolde)

		caller:MajAltisLifeMoneyATM()

		-- player tranfer

		DarkRP.notify( atmentity:GetNWEntity("owner"), 0, 5, "Tu a reçu un transfer de "..string.Comma(demande).."€")

		atmentity:GetNWEntity("owner"):SetAltisLifeMoneyATM(newsoldetransf)

		atmentity:GetNWEntity("owner"):MajAltisLifeMoneyATM()
	end
end)