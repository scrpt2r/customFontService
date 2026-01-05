--// Libs
local _types = require(script.Parent.Parent.global.types)

--// Variables
local _slashchar = string.byte("/", 1)
local _E = string.byte("E", 1)

--// Custom Types
type type.__parser = _types.parser
export type parser = type.__parser

--// Functions
function _trim(s)
    local from = s:match("^%s*()")
    return from > #s and "" or s:match(".*%S", from)
end

function _defaultEntityTable()
    return {quot = '"', apos = '\'', lt = '<', gt = '>', amp = '&', tab = '\t', nbsp = ' ', }
end

function _replaceEntities(s, entities)
    return s:gsub('&([^;]+);', entities)
end

function _createEntities(docEntities, resultEntities)
    local entities = resultEntities or _defaultEntityTable()
    for _,v in pairs(docEntities) do
        entities[v.name] = v.value
    end
    return entities
end

