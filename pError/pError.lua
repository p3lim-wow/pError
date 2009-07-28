--[[

 Copyright (c) 2009, Adrian L Lange
 All rights reserved.

 You're allowed to use this addon, free of monetary charge,
 but you are not allowed to modify, alter, or redistribute
 this addon without express, written permission of the author.

--]]

local next = next
local find, lower = string.find, string.lower

local pError = CreateFrame('Frame')
local orig = UIErrorsFrame:GetScript('OnEvent')

local function slashCommand(str)
	if(str == 'reset') then
		pErrorDB = {}
		print('|cffff8080pError:|r Database is now reset to default')
	elseif(str == 'list') then
		if(pErrorDB[1]) then
			print('|cffff8080pError:|r Listing database:')
			for _, v in next, pErrorDB do
				print('            |cff95ff95', v, '|r')
			end
		else
			print('|cffff8080pError:|r Database is empty')
		end
	elseif(#str > 0) then
		for k, v in next, pErrorDB do
			if(find(str, v)) then
				tremove(pErrorDB, k)
				return print('|cffff8080pError:|r Removed|cff95ff95', v, '|rfrom database')
			end
		end

		tinsert(pErrorDB, str)
		print('|cffff8080pError:|r Added|cff95ff95', str, '|rto database')
	end
end

local function onEvent(self, event, str, ...)
	if(event == 'UI_ERROR_MESSAGE' and pErrorDB[1]) then
		for k, v in next, pErrorDB do
			if(find(lower(str), v)) then
				return
			end
		end
	end

	return orig(self, event, str, ...)
end

pError:RegisterEvent('ADDON_LOADED')
pError:SetScript('OnEvent', function(self, event, name)
	if(name == 'pError') then
		self:SetScript('OnEvent', nil)

		if(not pErrorUpdated) then
			print('|cffff8080pError:|r Converted database into new format, thanks for updating!')
			pErrorDB = pErrorDB.blacklist
			pErrorUpdated = true
		end

		pErrorDB = pErrorDB or {}

		SLASH_pError1 = '/perror'
		SlashCmdList[name] = function(str) slashCommand(lower(str)) end

		UIErrorsFrame:SetScript('OnEvent', onEvent)
	end
end)