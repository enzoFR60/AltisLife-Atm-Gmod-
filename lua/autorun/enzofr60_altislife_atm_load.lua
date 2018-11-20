if SERVER then

    AddCSLuaFile( 'enzofr60_altislife_atm/config/sh_enzofr60_altislife_atm.lua' )
    AddCSLuaFile( 'enzofr60_altislife_atm/client/cl_enzofr60_altislife_atm.lua' )


    include( 'enzofr60_altislife_atm/config/sh_enzofr60_altislife_atm.lua' )
	include( 'enzofr60_altislife_atm/server/sv_enzofr60_altislife_atm.lua' )
else
    include( 'enzofr60_altislife_atm/config/sh_enzofr60_altislife_atm.lua' )
	
	include( 'enzofr60_altislife_atm/client/cl_enzofr60_altislife_atm.lua' )
end