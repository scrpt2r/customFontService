local types = {}

export type parser = {
	parse: () -> { [number]: {} },
}

export type main = {
	renderAsRich: ({}, {}) -> any,
	renderNormal: () -> any,
}

return types
