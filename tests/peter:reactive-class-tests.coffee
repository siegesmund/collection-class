


Tinytest.add "Create a ReactiveClassBase instance", (test) ->
	testClass = new ReactiveClassBase(TestCollection)
	test.notEqual testClass, undefined
	return

#
# Test Schema Creation
#

Tinytest.add "When an instance is created, getters and setters are created", (test) ->
	testClass = new ReactiveClassBase(TestCollection)
	test.notEqual testClass.getFirstName, undefined
	# test.notEqual testClass.getEmails, undefined
	# test.notEqual testClass.setOrganization, undefined
	# test.notEqual testClass.setAddress, undefined    ## Will break as long as list properties are disabled
	return

Tinytest.add "Set and get a nested string method", (test) ->
	testClass = new ReactiveClassBase(TestCollection)
	testClass.setFirstName('Test')
	testClass.setLastName('User')
	test.equal testClass.getFirstName(), 'Test'
	test.equal testClass.getLastName(), 'User'
	return

Tinytest.add "Properties and methods methods should not return private methods/properties", (test) ->
	testClass = new ReactiveClassBase(TestCollection)
	test.equal (_.filter testClass.properties(), (item) -> item.indexOf('_') > 0).length, 0
	test.equal (_.filter testClass.methods(), (item) -> item.indexOf('_') > 0).length, 0
	return

Tinytest.add "Properties method returns properties", (test) ->
	testClass = new ReactiveClassBase(TestCollection)
	testClass.setGender('male')
	test.equal testClass.properties()[0], 'profile'
	return

Tinytest.add "Invoking the _new method creates an object in the Mongo collection", (test) ->
	TestCollection2 = new Mongo.Collection null
	testClass = new ReactiveClassBase(TestCollection2)
	testClass._new()
	test.equal TestCollection2.find().fetch().length, 1
	return

Tinytest.add "A newly created registers its collection id", (test) ->
	TestCollection2 = new Mongo.Collection null
	testClass = new ReactiveClassBase(TestCollection2)
	testClass._new()
	collectionObject = TestCollection2.find().fetch()[0]
	test.equal testClass._id, collectionObject._id
	return

Tinytest.add "An instance's delete method removes its' corresponding document from the database", (test) ->
	TestCollection2 = new Mongo.Collection null
	testClass = new ReactiveClassBase(TestCollection2)
	testClass._new()
	test.equal TestCollection2.find().fetch().length, 1
	collectionObject = TestCollection2.find().fetch()[0]
	test.equal testClass._id, collectionObject._id
	testClass.delete()
	test.equal TestCollection2.find().fetch().length, 0
	return

Tinytest.add "An instance's delete method removes all properties from the instance", (test) ->
