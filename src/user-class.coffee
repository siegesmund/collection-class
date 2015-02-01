#
# requires alanning:roles
#

#
# This must be subclassed as there is no facility for creating new users
# It is a convenience Class that binds Meteor.users to CollectionClass
# and disables default document creation (so that subclasses can implement
# custom versions of Accounts
#

class User extends CollectionClass

	constructor: ->
		super({'collection': Meteor.users, 'createNewDocInCollection': false})

	userId: -> this.id()

	isInRole: (role) -> Roles.userIsInRole(this.id(), role)

	addToRole: (role) -> Roles.addUsersToRoles(this.id(), role)

