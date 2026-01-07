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
		text = nil,
	}

	return setmetatable(self, __main__)
end

function __main__:renderNormal() end

function __main__:renderAsRich(tree, inheritedProps)
	local currentProps = table.clone(inheritedProps or {})

	for k, node in ipairs(tree) do
		if type(node) == "string" then
			local length = string.len(node)
			local text = string.split(node, "")

			for i = 1, length do
				local t = self.fontData[unicode[text[i]]]
				print(k, t)
				print(k, text[i])
				print(k, unicode[text[i]])
			end

			if currentProps.size then
				print(tonumber(currentProps.size))
			end
			if currentProps.color then
				print(Color3.fromHex(currentProps.color))
			end

			print(node)
		elseif type(node) == "table" then
			local newProps = table.clone(currentProps)

			if node.tagName == "font" then
				if node.attributes.size then
					newProps.size = node.attributes.size
				end
				if node.attributes.color then
					newProps.color = node.attributes.color
				end
			end

			print(newProps)
			__main__.renderAsRich(node.children, newProps)
		end
	end
end

function __main__:newText(text: string, richText: boolean)
	self.text = text

	if richText then
		local parsedText = xmlParser.parse(self.text)
		self:renderAsRich(parsedText, {})
	else
	end
end

return __main__
