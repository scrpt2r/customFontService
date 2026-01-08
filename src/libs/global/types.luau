local types = {}

export type attributeMap = { [string]: string }

export type token = {
	type: "text" | "tag",
	content: string?,
	tagName: string?,
	attributes: attributeMap?,
	isClosing: boolean?,
	isSelfClosing: boolean?,
}

export type node = {
	tagName: string,
	attributes: attributeMap,
	children: { node | string },
}

export type main = {
	renderAsRich: ({}, {}) -> any,
	renderNormal: () -> any,
}

return types
