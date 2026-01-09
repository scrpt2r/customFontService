--// Lib Functions
local __main__ = {}
__main__.__index = __main__

function __main__.new(instance: string?, autoUpdate: boolean)
	local self = setmetatable({}, __main__)

	return self
end

return __main__
