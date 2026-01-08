--[[
	******************************************************************************
	* @file		: .../src/libs/XMLParser.lua
	* @author	: Scrpt2r
	* @date		: January 06 2026
	* @lastEdit	: January 07 2026 @ 21:57
	* @brief	: XML parser in luau.
	* @version	: 0.2.5
	******************************************************************************
	* @attention
	*
	* Copyright © 2026 Axon Corporation.
	* All rights reserved.
	*
	* This software is licensed under terms that can be found in the LICENSE file
	* in the root directory of this software component.
	* If no LICENSE file comes with this software, it is provided AS-IS.
	*
	******************************************************************************
--]]

--// Libs
local types = require(script.Parent.global.types)

--// Custom Types
type _token = types.token
export type token = _token

type _attributeMap = types.attributeMap
export type attributeMap = _attributeMap

type _node = types.node
export type node = _node

--// Lib Declaration
local XMLParser = {}
XMLParser.__index = XMLParser

--// Lib Funtcions
function XMLParser.new(options: { trimText: boolean, ignoreWhitespace: boolean })
	local self = {
		trimText = options.trimText ~= false,
		ignoreWhitespace = options.ignoreWhitespace ~= false,
	}

	return setmetatable(self, XMLParser)
end

function XMLParser:_tokenize(text: string): { token }
	local tokens = {}
	local tempText = text .. "<__EOF__>"

	for preText, slash, tagName, attributes in string.gmatch(tempText, "(.-)<(/?)([%w_]+)([^>]*)>") do
		if #preText > 0 then
			local content = preText

			if self.trimText then
				content = content:match("^%s*(.-)%s*$")
			end

			if not (self.ignoreWhitespace and content == "") then
				table.insert(tokens, {
					type = "text",
					content = content,
				})
			end
		end

		if tagName == "__EOF__" then
			break
		end

		local props: attributeMap = {}
		for key, value in string.gmatch(attributes, "([%w_]+)%s*=%s*[\"'](.-)[\"']") do
			props[key] = value
		end

		local isClosing = slash == "/"
		local isSelfClosing = attributes:find("/%s*$") ~= nil

		table.insert(tokens, {
			type = "tag",
			tagName = tagName,
			attributes = props,
			isClosing = isClosing,
			isSelfClosing = isSelfClosing,
		})
	end

	return tokens
end

function XMLParser:_buildTree(tokens: { token }): node
	local root: node = {
		tagName = "ROOT",
		attributes = {},
		children = {},
	}

	local stack = { root }

	for _, token in ipairs(tokens) do
		local currentParent = stack[#stack]

		if token.type == "text" then
			table.insert(currentParent.children, token.content)
		elseif token.type == "tag" then
			assert(token.tagName, "Invalid tag token")

			if token.isClosing then
				local last = stack[#stack]
				assert(last and last.tagName == token.tagName, ("Mismatched closing tag: </%s>"):format(token.tagName))

				table.remove(stack)
			else
				local node: node = {
					tagName = token.tagName,
					attributes = token.attributes or {},
					children = {},
				}

				table.insert(currentParent.children, node)

				if not token.isSelfClosing then
					table.insert(stack, node)
				end
			end
		end
	end

	return root
end

function XMLParser:_parse(text: string): node
	assert(type(text) == "string", "XMLParser.parse expects a string")

	local tokens = self:_tokenize(text)
	local tree = self:_buildTree(tokens)

	return tree
end

return XMLParser
