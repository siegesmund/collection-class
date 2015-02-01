#
# A small wrapper around MiniMongo that provides a
# class-based interface to Meteor/Mongo collections
# Requires aldeed:simple-schema, aldeed:collection2
#
#

class CollectionClass

	# Reactive Class
	constructor: (options) ->

		String::titleCase = -> this.charAt(0).toUpperCase() + this.substring(1)

		if options and options.collection
			this._collection = options.collection						# Save a reference to the collection
			if options.createNewDocInCollection isnt false
				if options._id											# If an id is passed
					this._id = options._id								# Set the instance id to the id

					if ! this.exists({_id: this.id()})					# If it doesn't exist in the collection
						this._save({_id: this.id()})					# create it
				else													# Otherwise, an id wasn't passed
					if ! options.arguments then options.arguments = {}	# if there are no arguments, create an empty object
					this._id = this._save(options.arguments)			# Create a new document with arguments and save the id

		# Create getters and setters for each property
		if this._schema() then this._createAccessors(this._schemaKeys())
		return

	##
	## Private Methods
	##

	_createAccessors: (objectKeys) ->
		this._createGetterAndSetterForPath objectPath for objectPath in objectKeys


	# Creates a getter and setter for a given object path
	_createGetterAndSetterForPath: (objectPath) ->
		# This code parses the object path stored in the simple-schema schemaKeys;
		# it condenses "." separated fields into camel case method names
		if objectPath.indexOf('$') < 0	# Do not create getters and setters for array items
			getterName = 'get' +  (_.reduce objectPath.split('.'), (memo, string) -> memo + string.titleCase()).titleCase()
			setterName = 'set' + (_.reduce objectPath.split('.'), (memo, string) -> memo +  string.titleCase()).titleCase()
			this[getterName] = this._getter(objectPath)
			this[setterName] = this._setter(objectPath)
		return

	#
	# Function factories to create the getters and setters
	#

	_getter: (objectPath) ->
		return ->
			modifier = {}
			modifier[objectPath] = 1
			p = this._collection.findOne({_id:this._id},{fields:modifier})
			(p = p[item]) for item in objectPath.split('.')
			return p

	_setter: (objectPath) ->
		return (value, callback) ->
			modifier = {}
			modifier[objectPath] = value
			return this._save({_id:this._id}, {$set:modifier}, callback)

	#
	# / End function factories
	#

	_save: (selector, modifier={}, callback) ->
		if this.id()
			this._collection.update(selector, modifier, callback)
		else
			this._collection.insert(selector, callback)

	_schema: -> # Returns a string representation of object keys specified by the schema
		if _.has(this._collection, '_c2')
			if _.has(this._collection._c2, '_simpleSchema')
				return this._collection._c2._simpleSchema
		return false

	_schemaKeys: ->
		if this._schema()._schemaKeys then return this._schema()._schemaKeys
	##
	## Public Instance Methods
	##

	id: ->
		return this._id

	methods: ->
		return _.filter _.functions(this), (item) -> item.indexOf('_') < 0 # filter out private methods

	exists: (selector) ->
		if this._collection.find(selector, {fields:{_id:1}}).count() is 0
			return false
		return true

	delete: ()->
		if this._collection.remove({_id:this.id()}) is 0		# Remove document from its collection
			return false
		else
			delete this[key] for key in Object.keys(this) when key not in ['id', 'methods', 'exists', 'delete', '_id', '_collection'] # Remove getters and setters from the object
			this._deleted = true
			return true

