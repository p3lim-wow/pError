--[[
	You can find more events to add to the "blacklist" from this list:
	http://www.wowwiki.com/WoW_Constants/Errors
	
	Just use ctrl+f (the find function)
--]]

local blacklist = {
	ERR_SPELL_FAILED_NO_COMBO_POINTS,   -- That ability requires combo points
	ERR_SPELL_FAILED_TARGETS_DEAD,      -- Your target is dead
	ERR_SPELL_FAILED_SPELL_IN_PROGRESS, -- Another action is in progress
	ERR_SPELL_FAILED_TARGET_AURASTATE,  -- You can't do that yet. (TargetAura)
	ERR_SPELL_FAILED_CASTER_AURASTATE,  -- You can't do that yet. (CasterAura)
	ERR_SPELL_FAILED_NO_ENDURANCE,      -- Not enough endurance
	ERR_SPELL_FAILED_BAD_TARGETS,       -- Invalid target
	ERR_SPELL_FAILED_NOT_MOUNTED,       -- You are mounted
	ERR_SPELL_FAILED_NOT_ON_TAXI,       -- You are in flight
	ERR_SPELL_FAILED_NOT_INFRONT,       -- You must be in front of your target
	ERR_SPELL_FAILED_NOT_IN_CONTROL,    -- You are not in control of your actions
	ERR_SPELL_FAILED_MOVING,            -- Can't do that while moving
	ERR_ATTACK_FLEEING,				-- Can't attack while fleeing.
	ERR_ITEM_COOLDOWN,				-- Item is not ready yet.
	ERR_GENERIC_NO_TARGET,          -- You have no target.
	ERR_ABILITY_COOLDOWN,           -- Ability is not ready yet.
	ERR_OUT_OF_ENERGY,              -- Not enough energy
	ERR_NO_ATTACK_TARGET,           -- There is nothing to attack.
	ERR_SPELL_COOLDOWN,             -- Spell is not ready yet. (Spell)
	ERR_OUT_OF_RAGE,                -- Not enough rage.
	ERR_INVALID_ATTACK_TARGET,      -- You cannot attack that target.
	ERR_OUT_OF_MANA,                -- Not enough mana
	ERR_NOEMOTEWHILERUNNING,        -- You can't do that while moving!
}

local lastEvent
local oldUIErrorsFrame_OnEvent = UIErrorsFrame_OnEvent
function UIErrorsFrame_OnEvent(event, msg, ...)
	for _,text in pairs(blacklist) do
		if(text and msg and msg == text) then return end
	end
	if(msg and msg == lastEvent) then return end
	return oldUIErrorsFrame_OnEvent(event, msg, ...)
end