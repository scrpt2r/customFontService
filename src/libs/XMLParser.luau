--[[
	******************************************************************************
	* @file		: .../src/libs/XMLParser.lua
	* @author	: Scrpt2r
	* @date		: January 06 2026
	* @lastEdit	: January 06 2026 @ 02:55
	* @brief	: XML parser in luau.
	* @version	: 0.1.3
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

--// Variables
local _slashchar = string.byte("/", 1)
local _E = string.byte("E", 1)

--// Functions
function _addText(t, txt)
	txt = txt:match("^%s*(.*%S)") or ""

	if #txt ~= 0 then
		t[#t + 1] = { text = txt }
	end
end

function _trim(s)
	local from = s:match("^%s*()")
	return from > #s and "" or s:match(".*%S", from)
end

function _defaultEntityTable()
	return { quot = '"', apos = "'", lt = "<", gt = ">", amp = "&", tab = "\t", nbsp = " " }
end

function _replaceEntities(s, entities)
	return s:gsub("&([^;]+);", entities)
end

function _createEntities(docEntities, resultEntities)
	local entities = resultEntities or _defaultEntityTable()
	for _, v in pairs(docEntities) do
		entities[v.name] = v.value
	end
	return entities
end

function _parse(s, evalEntities)
	s = s:gsub("<!%-%-(.-)%-%->", "")

	local entities, tentities = {}, {}
	local t, l = {}, {}

	if evalEntities then
		local pos = s:find("<[_%w]")

		if pos then
			s:sub(1, pos):gsub("<!ENTITY%s+([_%w]+)%s+(.)(.-)%2", function(name, q, entity)
				entities[#entities + 1] = { name = name, value = entity }
			end)

			tentities = _createEntities(entities)
			s = _replaceEntities(s:sub(pos), tentities)
		end
	end

	s:gsub("<([?!/]?)([-:_%w]+)%s*(/?>?)([^<]*)", function(type, name, closed, txt)
		if #type == 0 then
			local attrs, orderedattrs = {}, {}

			if #closed == 0 then
				local len = 0

				for all, aname, _, value, starttxt in string.gmatch(txt, "(.-([-_%w]+)%s*=%s*(.)(.-)%3%s*(/?>?))") do
					len = len + #all
					attrs[aname] = value
					orderedattrs[#orderedattrs + 1] = { name = aname, value = value }

					if #starttxt ~= 0 then
						txt = txt:sub(len + 1)
						closed = starttxt
						break
					end
				end
			end

			t[#t + 1] = { tag = name, attrs = attrs, children = {}, orderedattrs = orderedattrs }

			if closed:byte(1) ~= _slashchar then
				l[#l + 1] = t
				t = t[#t].children
			end

			_addText(t, txt)
		elseif "/" == type then
			if _E == name:byte(1) then
				txt:gsub("([_%w]+)%s+(.)(.-)%2", function(name, q, entity)
					entities[#entities + 1] = { name = name, value = entity }
				end, 1)
			end
		end
	end)

	return { children = t, entities = entities, tentities = tentities }
end

--// Lib Decleration
return {
	parse = _parse,
	defaultEntityTable = _defaultEntityTable,
	replaceEntities = _replaceEntities,
	createEntityTable = _createEntities,
}
