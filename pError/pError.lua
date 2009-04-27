--[[

 Copyright (c) 2009, Adrian L Lange
 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met: 

 · Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

 · Redistributions in binary form must reproduce the above copyright notice, this
   list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.

 · Neither the name of the add-on nor the names of its contributors may
   be used to endorse or promote products derived from this software without
   specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--]]

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
		elseif(pErrorDB.blacklist[1]) then
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