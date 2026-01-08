--// Lib Declaration
local toUnicode = {}

--// Lib Functions
function toUnicode.convert(letter: string)
	-- log
	assert(type(letter) == "string", "Given parameter must be a string.")
	return string.byte(letter)
end

return toUnicode
