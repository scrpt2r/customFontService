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

--// Functions
function mergeAttributes(parentAtts, nodeAttrs)
	local newAttrs = {}

	if parentAtts then
		for k, v in pairs(parentAtts) do
			newAttrs[k] = v
		end
	end

	if nodeAttrs then
		for k, v in pairs(nodeAttrs) do
			newAttrs[k] = v
		end
	end

	return newAttrs
end

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
	local currentAttributes = mergeAttributes(attributes, tree.attributes)

	for k, node in ipairs(tree.children) do
		if typeof(node) == "string" then
			local length = string.len(node)
			local text = string.split(node, "")

			for i = 1, length do
				local letter = text[i]
				local encodedLetter = unicode.convert(letter)
				local decodedLetter = self.fontData[encodedLetter]

				if currentAttributes and next(currentAttributes) then
					-- render "decodedLetter" with types;
					-- Gonna edit type: editType,
					-- To edit: currentAttributes
				else
					-- render "decodedLetter" normal
					print(decodedLetter)
				end
			end
		elseif typeof(node) == "table" then
			__main__.renderAsRich(node, currentAttributes)
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
