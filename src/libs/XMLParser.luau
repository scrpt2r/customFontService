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

--// Functions
function toTree(orgTable: { [number]: any }): { [number]: any }
	local root = {
		tagName = "ROOT",
		children = {},
	}

	local stack = { root }

	for _, segment in ipairs(orgTable) do
		local currentParent = stack[#stack]

		if segment.type == "text" then
			table.insert(currentParent.children, segment.content)
		elseif segment.type == "tag" then
			if not segment.isClosing then
				local newNode = {
					tagName = segment.tagName,
					attributes = segment.attributes,
					children = {},
				}

				table.insert(currentParent.children, newNode)
				table.insert(stack, newNode)
			end
		else
			if #stack > 1 then
				table.remove(stack)
			end
		end
	end

	return root.children
end

--// Lib Declaration
local XMLParser = {}

--// Lib Funtcions
function XMLParser.parse(text)
	local segments = {}
	local tempText = text .. "<__EOF__>"

	local tagStack = {}
	local currentIDCounter = 0

	for preText, slash, tagName, attributes in string.gmatch(tempText, "(.-)<(/?)([%w_]+)([^>]*)>") do
		if #preText > 0 then
			table.insert(segments, {
				type = "text",
				content = preText,
				parentId = tagStack[#tagStack] and tagStack[#tagStack].id,
			})
		end

		if tagName == "__EOF__" then
			break
		end

		local props = {}
		for key, value in string.gmatch(attributes, "([%w_]+)%s*=%s*[\"'](.-)[\"']") do
			props[key] = value
		end

		local isClosing = (slash == "/")
		local segmentID = nil

		if not isClosing then
			currentIDCounter += 1
			segmentID = currentIDCounter

			table.insert(tagStack, { tagName = tagName, id = segmentID })
		else
			local lastOpenTag = tagStack[#tagStack]

			if lastOpenTag and lastOpenTag.tagName == tagName then
				segmentID = lastOpenTag.id
				table.remove(tagStack)
			end
		end

		table.insert(segments, {
			type = "tag",
			isClosing = isClosing,
			tagName = tagName,
			attributes = props,
			id = segmentID,
		})
	end

	return toTree(segments)
end

return XMLParser
