#
#
# requires alanning:roles
#

class User extends CollectionClass

	constructor: (options) ->
		super()
		this._collection = Meteor.users

		if options._id
			_.extend this, this._collection.findOne {_id:options._id}, {fields:{services:0}}
		else
			this._id = Accounts.createUser options

		if Meteor.isClient
			this.track()

	save: ->
		this._collection.update {_id:this._id}, this._toObject()


	userId: -> true


	isInRole: -> true


	addToRole: -> true
