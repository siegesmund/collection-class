# A reactive interface for objects and documents
# Uses simple schema


## Todo: style getters and setters to taste
## Todo: deal with list functions

class ReactiveClassBase

	# Reactive Class
	constructor: (collection) ->
		if collection
			this._collection = collection

			schema = this._schema()
			this._arrayProperties = []

			if schema
				for item in schema._schemaKeys
					if item.indexOf('$') < 0			# Do not create getters and setters for array items
						items = item.split('.')
						propertyName = items[items.length-1]
						getterName = 'get' + propertyName.charAt(0).toUpperCase() + propertyName.substring(1)
						setterName = 'set' + propertyName.charAt(0).toUpperCase() + propertyName.substring(1)
						this[getterName] = this._getter(items)
						this[setterName] = this._setter(items)
					else
						this._arrayProperties.push item
		return

	##
	## Private Methods
	##

	#
	# Function factories to create the getters and setters
	#

	_getter: (items) ->
		_this = this
		return ->
			p = _this
			for item in items
				p = p[item]
			return p

	_setter: (items) ->
		_this = this		# store a reference to the base object as we won't be able to access it inside the closure
		return (value) ->
			p = _this					# store a reference to the base object that we can traverse
			for item,index in items			# need to get the index so we can tell where we're at on the array
				if index < (items.length-1) # if we're at the end, skip to setting the value
					if ! p[item]
						p[item] = {} 	# create an object if one doesn't exist (but only if we're not at the end)
					p = p[item] 		# advance one level
			p[item] = value				# when we're at the end, set the value
			_this._save()
			return

	#
	# / End function factories
	#

	_new: ->
		this._id = this._collection.insert(this._toObject())

	_save: -> true
		#this._collection.update({_id:this._id}, this._toObject())

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

	track: ->
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
		if this._id
			this._collection.remove {_id:this._id}

		for key,value of this # Remove all properties
			delete this[key]