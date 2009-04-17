local next = next
local find = string.find
local lower = string.lower

local orig = UIErrorsFrame:GetScript('OnEvent')

local function msg(...)
	print(format('|cffff8080pError:|r %s', ...))
end

local function slashCommand(str)
	str = lower(str)

	if(str == 'reset') then
		pErrorDB = {all = false, blacklist = {}}
		msg('Savedvariables are now reset to default')
	elseif(str == 'all') then
		pErrorDB.all = not pErrorDB.all
		msg(format('Filtering all events turned %s', pErrorDB.all and 'on' or 'off'))
	elseif(str == 'list') then
		if(pErrorDB.all) then
			msg('Filtering all events!')
		elseif(not pErrorDB.blacklist[1]) then
			msg('Database is empty')
		else
			msg('Listing database of events:')

			for k, v in next, pErrorDB.blacklist do
				msg(format('|cff95ff95 \'%s\'|r', v))
			end
		end
	elseif(#str > 0) then
		if(pErrorDB.all) then
			msg('Can\'t add to database, pError is filtering all events')
		else
			for k, v in next, pErrorDB.blacklist do
				if(find(str, v)) then
					tremove(pErrorDB.blacklist, k)
					return msg(format('Removed |cff95ff95\'%s\'|r from the database', v))
				end
			end

			tinsert(pErrorDB.blacklist, str)
			msg(format('Added |cff95ff95\'%s\'|r to the database', str))
		end
	else
		msg('Please provide an error string')
	end
end

local function onEvent(self, event, str, ...)
	if(event == 'UI_ERROR_MESSAGE') then
		if(pErrorDB.all) then
			return
		else
			for k, v in next, pErrorDB.blacklist do
				if(find(lower(str), v)) then return end
			end
		end
	end

	return orig(self, event, str, ...)
end

local function onLoad(self, event, addon)
	if(addon ~= 'pError') then return end
	self:UnregisterEvent(event)

	pErrorDB = pErrorDB or {all = false, blacklist = {}}

	SLASH_pError1 = '/perror'
	SlashCmdList.pError = slashCommand

	UIErrorsFrame:SetScript('OnEvent', onEvent)
end

local addon = CreateFrame('Frame')
addon:RegisterEvent('ADDON_LOADED')
addon:SetScript('OnEvent', onLoad)