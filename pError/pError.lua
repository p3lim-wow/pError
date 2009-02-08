local function OnEvent(self, event, ...)
	if(event == 'UI_ERROR_MESSAGE') then
		local str = ...
		if(pErrorDB2.all) then
			return
		else
			for k,v in ipairs(pErrorDB2.blacklist) do
				if(string.find(string.lower(str), string.lower(v))) then return end
			end
		end
	end

	return UIErrorsFrame_OnEvent(self, event, ...)
end

local function OnLoad(self, event, addon)
	if(addon ~= 'pError') then return end

	pErrorDB2 = pErrorDB2 or {all = false, blacklist = {}}

	UIErrorsFrame:SetScript('OnEvent', OnEvent)
	self:UnregisterEvent(event)
end

local function pprint(...)
	print(string.format('|cffff8080pError:|r %s', ...))
end

local addon = CreateFrame('Frame')
addon:RegisterEvent('ADDON_LOADED')
addon:SetScript('OnEvent', OnLoad)

SLASH_PERROR1 = '/perror'
SlashCmdList.PERROR = function(str)
	if(str == 'reset') then
		pErrorDB2 = {all = false, blacklist = {}}
		pprint('Savedvariables is now reset')
	elseif(str == 'all') then
		pErrorDB2.all = not pErrorDB2.all
		pprint(string.format('Filtering of all events turned %s', pErrorDB2.all and 'on' or 'off'))
	elseif(str == 'list') then
		if(pErrorDB2.all) then
			pprint('Filtering all events!')
		elseif(not pErrorDB2.blacklist[1]) then
			pprint('Database is empty')
		else
			pprint('Listing database of events:')
			for k,v in pairs(pErrorDB2.blacklist) do
				pprint(format('  \'%s\'', v))
			end
		end
	elseif(#str > 0) then
		if(pErrorDB2.all) then
			pprint('Can\'t add to database, pError is filtering all events')
		else
			local num = 0
			for k,v in ipairs(pErrorDB2.blacklist) do
				num = num + 1
				if(string.find(string.lower(str), string.lower(v))) then
					table.remove(pErrorDB2.blacklist, num)
					pprint(format('\'%s\' removed', v))
					return
				end
			end

			table.insert(pErrorDB2.blacklist, str)
			pprint(format('Added \'%s\' to the database', str))
		end
	else
		pprint('Please provide an error string')
	end
end