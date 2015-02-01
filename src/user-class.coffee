#
# requires alanning:roles
#

class User extends CollectionClass

	constructor: (options) ->
		super()
		this._collection = Meteor.users
		this._createAccessorMethods()
		if not options._id
			this._id = Accounts.createUser()

	userId: -> true


	isInRole: -> true


	addToRole: -> true
