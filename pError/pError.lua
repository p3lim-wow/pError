--[[
	You can find more errors to add to the blacklist below at this list:
	http://www.wowwiki.com/WoW_Constants/Errors
	
	Just use CTRL+F to find the right constant
--]]

local blacklist = {
	INTERRUPTED, -- Interrupted
	ERR_NO_ATTACK_TARGET, -- There is nothing to attack.
	SPELL_FAILED_NO_COMBO_POINTS, -- That ability requires combo points
	ERR_INVALID_ATTACK_TARGET, -- You cannot attack that target.
	ERR_OUT_OF_RANGE, -- Out of range.
	ERR_BADATTACKPOS, -- You are too far away!
	SPELL_FAILED_NOT_BEHIND, -- You must be behind your target.
	ERR_ABILITY_COOLDOWN, -- Ability is not ready yet.
	ERR_GENERIC_NO_TARGET, -- You have no target.
	SPELL_FAILED_UNIT_NOT_INFRONT, -- Target needs to be in front of you
	SPELL_FAILED_MOVING , -- Can't do that while moving
	ERR_OUT_OF_RAGE, -- Not enough rage
	ERR_BADATTACKFACING, -- You are facing the wrong way
	ERR_OUT_OF_ENERGY, -- Not enough energy
	ERR_OUT_OF_MANA, -- Not enough mana
	SPELL_FAILED_TOO_CLOSE, -- Target too close
	SPELL_FAILED_TARGETS_DEAD, -- Your target is dead
	SPELL_FAILED_STUNNED, -- Can't do that while stunned
	ERR_SPELL_COOLDOWN, -- Spell is not ready yet.
	SPELL_FAILED_CASTER_DEAD, -- You are dead
	SPELL_FAILED_ONLY_STEALTHED, -- You must be in stealth mode.
	ERR_ATTACK_FLEEING, -- Can't attack while fleeing.
	ERR_ATTACK_STUNNED, -- Can't attack while stunned.
	SPELL_FAILED_NOT_IN_CONTROL, -- You are not in control of your actions
	ERR_ITEM_COOLDOWN, -- Item is not ready yet.
	ERR_ATTACK_CONFUSED, -- Can't attack while confused.
	SPELL_FAILED_LINE_OF_SIGHT, -- Target not in line of sight
	SPELL_FAILED_SPELL_IN_PROGRESS, -- Another action is in progress
	SPELL_FAILED_NOT_SHAPESHIFT, -- You are in shapeshift form
	ERR_USE_TOO_FAR, -- You are too far away.
	ERR_INVALID_RAID_TARGET, -- You cannot raid target enemy players
	SPELL_FAILED_TARGET_NOT_PLAYER, -- Target is not a player
	SPELL_FAILED_NOPATH, -- No path available
	SPELL_FAILED_TARGET_AURASTATE, -- You can't do that yet
	SPELL_FAILED_TARGET_AFFECTING_COMBAT, -- Target is in combat
	ERR_ATTACK_DEAD, -- Can't attack while dead.
}

local OrigHandler = UIErrorsFrame_OnEvent
function UIErrorsFrame_OnEvent(self, event, msg, ...)
	local db = _G.pErrorDB or {}
	if(event == 'UI_ERROR_MESSAGE') then
		for _, i in ipairs(blacklist) do
			if(msg == i) then return end
		end
	end

	return OrigHandler(self, event, msg, ...)
end