export type parser = {
	parse: () -> any,
	defaultEntityTable: () -> { [string]: string },
	replaceEntities: () -> string,
	createEntityTable: () -> { [string]: string },
}
