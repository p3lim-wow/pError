local addon = CreateFrame('Frame')
local orig = UIErrorsFrame_OnEvent

local defaults = {
	[ERR_OUT_OF_ENERGY] = true,
	[ERR_SPELL_COOLDOWN] = true,
	[ERR_OUT_OF_RANGE] = true,
	[ERR_BADATTACKPOS] = true,
	[ERR_ABILITY_COOLDOWN] = true,
}

local function OnLoad(self, event, addon)
	if(addon ~= 'pError') then return end

	pErrorDB = pErrorDB or {}
	for k,v in pairs(defaults) do
		if(type(pErrorDB[k]) == 'nil') then
			pErrorDB[k] = v
		end
	end

	self:UnregisterEvent(event)
end

local function OnEvent(self, event, ...)
	if(event == 'UI_ERROR_MESSAGE') then
		local str = ...
		for k,v in pairs(pErrorDB) do
			if(str == k and v) then return end
		end
	end

	return orig(self, event, ...)
end

addon:RegisterEvent('ADDON_LOADED')
addon:SetScript('OnEvent', OnLoad)
UIErrorsFrame:SetScript('OnEvent', OnEvent)

SLASH_PERROR1 = '/perror'
SlashCmdList.PERROR = function(str)
	if(str == 'reset') then
		pErrorDB = {}
		print('|cffff8080pError:|r Savedvariables is now reset')
	elseif(str == 'list') then
		print('|cffff8080pError:|r Listing database of events and their states:')
		for k,v in pairs(pErrorDB) do
			print(format('"%s"   %s', k, v and '|cff00ff00Enabled|r' or '|cffff0000Disabled|r'))
		end
	elseif(#str > 0) then
		for k,v in pairs(pErrorDB) do
			if(k == str) then
				pErrorDB[k] = not v
				print(format('|cffff8080pError:|r %s "%s"', v and '|cffff0000Disabled|r' or '|cff00ff00Enabled|r', k))
				return
			end
		end

		pErrorDB[str] = true
		print(format('|cffff8080pError:|r Added "%s" to the database', str))
	else
		print('|cffff8080pError:|r Please provide an error string')
	end
end