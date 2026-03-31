--// Services
local runService = game:GetService("RunService")

--// Libs
local textSpriteHandler = require(script.Parent.libs.textSpriteHandler)
local types = require(script.Parent.libs.global.types)
local xmlParser = require(script.Parent.libs.XMLParser)
local unicode = require(script.Parent.libs.unicodeText)
--local fontEditor = require(script.Parent.libs.fontEditor)

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
	local self = setmetatable({
		fontData = require(fonts[fontName].fontData),
		imageData = "rbxassetid://109837085959106",

		richText = true,

		cursor = Vector2.new(0, 0),

		lineHeight = 32,
		updateConn = nil,

		text = "",
		oldText = "",
		instance = nil,

		position = Vector2.new(0, 0),

		parent = nil,

		sprites = {},
	}, __main__)

	if autoUpdate then
		self.updateConn = runService.RenderStepped:Connect(function(deltaTime)
			if self.text ~= self.oldText then
				print(self.parent)
				print(deltaTime)
				local parsedText = myParser:_parse(self.text)
				self:renderAsRich(parsedText, nil, deltaTime)
			elseif not self.richText and self.text ~= self.oldText then
			end
		end)
	end

	return self
end

function __main__:renderNormal() end

function __main__:renderAsRich(tree, attributes, deltaTime: number)
	local currentAttributes = mergeAttributes(attributes, tree.attributes)

	for k, node in ipairs(tree.children) do
		if typeof(node) == "string" then
			for k = 1, #self.sprites do
				self.sprites[k]:updateSprite(deltaTime)

				if self.sprites[k].instance.parent ~= self.parent then
					self.sprites[k].instance.Parent = self.parent
				end
			end

			if self.text ~= self.oldText then
				local oldLenght = string.len(self.oldText :: string)
				self.oldText = self.text

				local length = string.len(node)
				local text = string.split(node, "")
				local diffrence = (length - oldLenght)
				local totalXLenght = 0

				if not (diffrence == 0) then
					if diffrence > 0 then
						diffrence = math.abs(diffrence)

						for k = 1, diffrence do
							table.insert(self.sprites, textSpriteHandler.new("ImageLabel", true))
						end
					else
						diffrence = math.abs(diffrence)

						for k = 1, diffrence do
							self.sprites[k]:destroySprite()
						end

						local newSprites = {}
						for k = 1, #self.sprites do
							if not self.sprites[k].destroyed then
								table.insert(newSprites, self.sprites[k])
							end
						end

						self.sprites = newSprites
					end
				end

				for i = 1, length do
					if currentAttributes and next(currentAttributes) then
						self.sprites[i]:loadRichImg(self.imageData, currentAttributes)
					else
						self.sprites[i]:loadImg(self.imageData)
					end

					self.sprites[i].size = Vector2.new(1, 1)

					local letter = text[i]
					local encodedLetter = unicode.convert(letter)
					local decodedLetter = self.fontData[encodedLetter] or self.fontData[63]

					local anim = {
						framerate = 24,
						frames = {
							[1] = {
								imageRectSize = Vector2.new(decodedLetter.width, decodedLetter.height),
								imageRectOffset = Vector2.new(decodedLetter.x, decodedLetter.y),
								imageSize = Vector2.new(decodedLetter.width, decodedLetter.height),
								offset = Vector2.new(decodedLetter.xoffset, (decodedLetter.yoffset / 2)),
							},
						},
					}

					self.sprites[i]:addAnim(letter, anim)
					self.sprites[i]:play(letter, true)

					if letter == " " then
						totalXLenght += decodedLetter.xadvance * 1
					else
						totalXLenght += decodedLetter.width * 1
					end
				end

				local xStart = self.position.X

				local currentX = xStart
				local currentY = self.position.Y

				for k = 1, length do
					local letter = text[k + 1] or text[k]
					local encodedLetter = unicode.convert(letter)
					local decodedLetter = self.fontData[encodedLetter] or self.fontData[63]
					local xAdvance = decodedLetter.width

					if letter == " " then
						xAdvance = decodedLetter.xadvance
					end

					self.sprites[k].position = Vector2.new(currentX, currentY)
					currentX += xAdvance * 1
				end
			end
		elseif typeof(node) == "table" then
			self:renderAsRich(node, currentAttributes)
		end
	end
end

function __main__:setParent(parent: GuiObject?)
	self.parent = parent

	for _, sprite in ipairs(self.sprites) do
		if sprite.instance then
			sprite.instance.Parent = parent
		end
	end
end

function __main__:newText(text: string, richText: boolean)
	self.richText = richText
	self.text = text
end

return __main__
