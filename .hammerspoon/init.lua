local application = require('hs.application')
local hotkey = require('hs.hotkey')

local previousApplication = nil

hotkey.bind({ 'command' }, '`', function()
	local alacritty = application.get('org.alacritty')
	if not alacritty:isFrontmost() then
		previousApplication = application.frontmostApplication()
		alacritty:setFrontmost()
	elseif previousApplication then
		previousApplication:setFrontmost()
	end
end)

hotkey.bind({ 'option' }, 'space', function()
	local chatGPT = application.get('com.openai.chat')
	if not chatGPT:isFrontmost() then
		previousApplication = application.frontmostApplication()
		chatGPT:setFrontmost()
	elseif previousApplication then
		previousApplication:setFrontmost()
	end
end)
