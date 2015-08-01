/*
 * ULX Source Bans
 * Version: 0.2.3a
 */
local CATEGORY_NAME = "Source Bans"

function ulx.sban( calling_ply, target_ply, minutes, reason )
	if target_ply:IsBot() then
		ULib.tsayError( calling_ply, "Cannot ban a bot", true )
		return
	end
	
	if reason == "" or reason == "reason" then
		ULib.tsayError( calling_ply, "Cannot ban without a reason", true )
		return
	end
	
	local name = target_ply:GetName()

	SBAN.Player_Ban( target_ply, minutes*60, reason, calling_ply:SteamID() )
	
	local time = "for #i minute(s)"
	if minutes == 0 then time = "permanently" end
	local str = "#A banned #s " .. time
	if reason and reason ~= "" then str = str .. " (#s)" end
	ulx.fancyLogAdmin( calling_ply, str, name, minutes ~= 0 and minutes or reason, reason )
end
local sban = ulx.command( CATEGORY_NAME, "ulx sban", ulx.sban, "!sban" )
sban:addParam{ type=ULib.cmds.PlayerArg }
sban:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
sban:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
sban:defaultAccess( ULib.ACCESS_ADMIN )
sban:help( "Bans target." )

function ulx.sbanid( calling_ply, steamid, minutes, reason )
	steamid = steamid:upper()
	if not ULib.isValidSteamID( steamid ) then
		ULib.tsayError( calling_ply, "Invalid steamid." )
		return
	end

	local target_ply = nil 
	local plys = player.GetAll()
	for i=1, #plys do
		if plys[ i ]:SteamID() == steamid then
			target_ply = plys[ i ]
			break
		end
	end

	if(target_ply != nil) then
		name = target_ply:GetName()
		SBAN.Player_Ban( target_ply, minutes*60, reason, calling_ply:SteamID() )
	else
		SBAN.Player_DoBan( "unknown", steamid, "[Unknown]", minutes*60, reason, calling_ply:SteamID() )
	end

	local time = "for #i minute(s)"
	if minutes == 0 then time = "permanently" end
	local str = "#A banned steamid #s "
	if name then
		steamid = steamid .. "(" .. name .. ") "
	end
	str = str .. time
	if reason and reason ~= "" then str = str .. " (#4s)" end
	ulx.fancyLogAdmin( calling_ply, str, steamid, minutes ~= 0 and minutes or reason, reason )
end
local sbanid = ulx.command( CATEGORY_NAME, "ulx sbanid", ulx.sbanid )
sbanid:addParam{ type=ULib.cmds.StringArg, hint="steamid" }
sbanid:addParam{ type=ULib.cmds.NumArg, hint="minutes, 0 for perma", ULib.cmds.optional, ULib.cmds.allowTimeString, min=0 }
sbanid:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=ulx.common_kick_reasons }
sbanid:defaultAccess( ULib.ACCESS_SUPERADMIN )
sbanid:help( "Bans steamid." )