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
local myParser = xmlParser.new({
	trimText = true,
	ignoreWhitespace = true,
})

local backupTable = nil

--// Lib Declaration
local __main__ = {}

--// Lib Variables
__main__.__index = __main__

--// Lib Functions
function __main__.newFont(fontName: string)
	local self = {
		fontData = require(fonts[fontName].fontData),
		text = nil,
	}

	return setmetatable(self, __main__)
end

function __main__:renderNormal() end

function __main__:renderAsRich(tree, attributes)
	for k, node in ipairs(tree.children) do
		if typeof(node) == "string" then
			local length = string.len(node)
			local text = string.split(node, "")

			if attributes then
				local editType = tree.tagName

				if backupTable then
					for i, v in attributes do
						table.insert(backupTable, v)
					end
					for i, v in backupTable do
						print(editType)
						-- edit font with edit type load all edit types
					end
				else
					for i, v in attributes do
						print(editType)
					end
				end
			end

			for i = 1, length do
				local encodedLetter = unicode.convert(text[i])
				local decodedLetter = self.fontData[encodedLetter]

				print(text, decodedLetter)
			end
		elseif typeof(node) == "table" then
			if k == 1 then
				backupTable = {}

				for i, v in node.attributes do
					table.insert(backupTable, v)
				end
			else
				table.clear(backupTable)
				backupTable = nil
			end

			__main__.renderAsRich(node, node.attributes)
		end
	end
end

function __main__:newText(text: string, richText: boolean)
	self.text = text

	if richText then
		local parsedText = myParser:_parse(self.text)
		self:renderAsRich(parsedText, nil)
	else
	end
end

return __main__
