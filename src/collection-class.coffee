# A small wrapper around MiniMongo that provides a class-based interface to Meteor/Mongo collections
#
# Requires aldeed:simple-schema, aldeed:collection2
#
# Can:
# Create a new object and manipulate its' properties using getters and setters
# Finding and working with existing objects is left to subclasses

class CollectionClass

	# Reactive Class
	constructor: (options) ->

		String::titleCase = -> this.charAt(0).toUpperCase() + this.substring(1)

		if options and options.collection
			this._collection = options.collection				# Save a pointer to the collection
			this._id = this._collection.insert({})		# Create a new document
			this._createAccessorMethods objectPath for objectPath in this._schema()._schemaKeys when this._schema()
		return

	##
	## Private Methods
	##

	# Creates a getter and setter for a given object path
	_createAccessorMethods: (objectPath) ->
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
		return (value) ->
			modifier = {}
			modifier[objectPath] = value
			return this._collection.update({_id:this._id}, {$set:modifier})

	#
	# / End function factories
	#

	_save: (path, value) ->
		modifier = {}
		modifier[path] = value
		return this._collection.update({_id:this._id}, {$set:modifier})

	_toObject: ->
		return _.pick(this, this.properties())

	_schema: -> # Returns a string representation of object keys specified by the schema
		if _.has(this._collection, '_c2')
			if _.has(this._collection._c2, '_simpleSchema')
				return this._collection._c2._simpleSchema
		return false

	##
	## Public Methods
	##

	id: ->
		return this._id

	methods: ->
		return _.filter _.functions(this), (item) -> item.indexOf('_') < 0 # filter out private methods

	properties: ->
		return _.filter (_.difference Object.keys(this), this.methods()), (item) -> item.indexOf('_') < 0

	delete: ->
		response = this._collection.remove {_id:this._id}			# Remove document from its collection
		if response is 0
			return false
		else
			return true

