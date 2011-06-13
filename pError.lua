--[[

 Copyright (c) 2009-2011, Adrian L Lange
 All rights reserved.

 You're allowed to use this addon, free of monetary charge,
 but you are not allowed to modify, alter, or redistribute
 this addon without express, written permission of the author.

--]]

local addonName = ...

local find, lower = string.find, string.lower

local LISTENING = false

local addon = CreateFrame('Frame', addonName)
local orig = UIErrorsFrame:GetScript('OnEvent')

local function slashCommand(str)
	if(str == 'reset') then
		pErrorDB = {}
		print('|cffff8080pError:|r Database is now reset to default')
	elseif(str == 'list') then
		if(pErrorDB[1]) then
			print('|cffff8080pError:|r Listing database:')
			for k, v in pairs(pErrorDB) do
				print('            |cff95ff95', v, '|r')
			end
		else
			print('|cffff8080pError:|r Database is empty')
		end
	elseif(str == 'listen') then
		LISTENING = not LISTENING
		print('|cffff8080pError:|r Listening to any errors now ', LISTENING and 'enabled' or 'disabled')
	elseif(#str > 0) then
		for k, v in pairs(pErrorDB) do
			if(find(str, v)) then
				table.remove(pErrorDB, k)
				return print('|cffff8080pError:|r Removed|cff95ff95', v, '|rfrom database')
			end
		end

		table.insert(pErrorDB, str)
		print('|cffff8080pError:|r Added|cff95ff95', str, '|rto database')
	end
end

local function errorEvent(self, event, str, ...)
	if(event == 'UI_ERROR_MESSAGE' and pErrorDB[1]) then
		for k, v in pairs(pErrorDB) do
			if(find(lower(str), v)) then
				return
			end
		end

		if(LISTENING) then
			table.insert(pErrorDB, str)
			print('|cffff8080pError:|r Added|cff95ff95', str, '|rto database')
		end
	end

	return orig(self, event, str, ...)
end

addon:RegisterEvent('ADDON_LOADED')
addon:SetScript('OnEvent', function(self, event, name)
	if(name ~= addonName) then return end

	self:UnregisterEvent(event)
	pErrorDB = pErrorDB or {}

	SLASH_pError1 = '/perror'
	SlashCmdList[addonName] = function(str) slashCommand(lower(str)) end

	UIErrorsFrame:SetScript('OnEvent', errorEvent)
end)
