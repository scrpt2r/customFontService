--// Services
--local

--// Libs
local types = require(script.Parent.libs.global.types)
local xmlParser = require(script.Parent.libs.XMLParser)
local unicode = require(script.Parent.libs.unicodeText)

--// Custom Types
type type__main = types.main
export type main = type__main

--// Variables
local fonts = script.Parent.fonts

--// Lib Declaration
local __main__ = {}

--// Lib Variables
__main__.__index = __main__

--// Lib Functions
function __main__.newFont(fontName: string)
	local self = {
		fontData = require(fonts[fontName].fontData),
	}

	return setmetatable(self, __main__)
end

function __main__:renderNormal() end

function __main__.renderAsRich() end

function __main__:newText(richText: boolean)
	if richText then
	else
	end
end

return __main__
