

class ReactiveUser extends ReactiveClassBase

	constructor: (options) ->
		super(Meteor.users)
		if options._id
			_.extend this, this._collection.findOne {_id:options._id}, {fields:{services:0}}
		else
			this._id = Accounts.createUser options
		this.track()

		if options.callback
			callback(options.args)

	save: ->
		this._collection.update {_id:this._id}, this._toObject()