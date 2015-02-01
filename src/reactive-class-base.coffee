# A simple interface for objects and documents
# Requires aldeed:simple-schema, aldeed:collection2

# Can:
# Create a new object and manipulate its' properties using getters and setters
# Finding and workign with existing objects is left to subclasses

class ReactiveClassBase

	# Reactive Class
	constructor: (collection) ->

		String::titleCase = -> this.charAt(0).toUpperCase() + this.substring(1)
		if collection
			this._collection = collection				# Save a pointer to the collection
			this._id = this._collection.insert({})		# Create a new document
			this._createAccessorMethods objectPath for objectPath in this._schema()._schemaKeys when this._schema()
		return

	##
	## Private Methods
	##

	# Creates a getter and setter for a given object path
	_createAccessorMethods: (objectPath) ->
		# Utility function to capitalize the first letter of a string

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

	# this walks down the object path, and returns a function with a
	# stored reference to the properties' path on the class instance
	_getter: (objectPath) ->
		p = this
		return -> (p = p[item]) for item in objectPath.split('.'); return p

	_setter: (objectPath) ->
		_this = this							# store a reference to the base object as we won't be able to access it inside the closure
		return (value) ->
			p = _this							# store a reference to the base object that we can traverse

			# This code is all to set the local value
			items = objectPath.split('.')
			for item,index in items			# need to get the index so we can tell where we're at on the array
				if index < (items.length-1) # if we're at the end, skip to setting the value
					if ! p[item]
						p[item] = {} 	# create an object if one doesn't exist (but only if we're not at the end)
					p = p[item] 		# advance one level
			oldValue = p[item]
			p[item] = value				# when we're at the end, set the value

			if _this._save(objectPath, value) is 0
				p[item] = oldValue
				throw new Error "Error: Mongo document not found. Value not set."
			return

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

	track: ->
		if Meteor.isClient
			_this = this
			Tracker.autorun ->
				obj = _this._collection.findOne({_id:_this._id})
				_.extend _this, obj
		return

	methods: ->
		return _.filter _.functions(this), (item) -> item.indexOf('_') < 0 # filter out private methods

	properties: ->
		return _.filter (_.difference Object.keys(this), this.methods()), (item) -> item.indexOf('_') < 0

	delete: ->
		affected = this._collection.remove {_id:this._id}			# Remove document from its collection
		if affected is 1
			delete this[key] for key in Object.keys(this) 	# Remove all properties and methods
		else
			throw new Error 'error when attempting to delete document'
		return
