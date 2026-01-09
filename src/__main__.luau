--// Services
local runService = game:GetService("RunService")

--// Libs
local types = require(script.Parent.libs.global.types)
local xmlParser = require(script.Parent.libs.XMLParser)
local unicode = require(script.Parent.libs.unicodeText)
local fontEditor = require(script.Parent.libs.fontEditor)

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
__main__.__index = __main__

--// Lib Functions
function __main__.newFont(fontName: string, autoUpdate: boolean)
	local self = {
		fontData = require(fonts[fontName].fontData),
		text = nil,
		cursor = Vector2.new(0, 0),
		referenceSize = Vector2.new(1920, 1080),
		lineHeight = 32,
		updateConn = nil,
	}

	if autoUpdate then
		self.updateConn = runService.RenderStepped:Connect(function(deltaTime) end)
	end

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

				if letter == " " then
					self.cursor = self.cursor + Vector2.new(20, 0)
					continue
				end

				local encodedLetter = unicode.convert(letter)
				local decodedLetter = self.fontData[encodedLetter] or self.fontData[63]

				if currentAttributes and next(currentAttributes) then
				else
				end
			end
		elseif typeof(node) == "table" then
			self:renderAsRich(node, currentAttributes)
		end
	end
end

function __main__:setParent(parent: GuiObject?) end

function __main__:newText(text: string, richText: boolean)
	self.text = text

	if richText then
		local parsedText = myParser:_parse(self.text)
		self:renderAsRich(parsedText, nil)
	else
	end
end

return __main__
