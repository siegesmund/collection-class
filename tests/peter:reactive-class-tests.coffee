

testClass = undefined

tearDown = ->
	TestCollection.remove({})
	testClass = undefined

setUp = ->
	testClass = new ReactiveClassBase(TestCollection)


Tinytest.add "ReactiveClassBase: creates a ReactiveClassBase instance", (test) ->
	setUp()
	test.notEqual testClass, undefined
	tearDown()
	return

# Test using basic schema
Tinytest.add "ReactiveClassBase: creates getters and setters when an instance is created", (test) ->
	setUp()
	test.notEqual testClass.getFirstName, undefined
	tearDown()
	return

# Test using basic schema
Tinytest.add "ReactiveClassBase: set and get methods function in a nested string method", (test) ->

	setUp()

	# Set properties
	testClass.setFirstName('Test')
	testClass.setLastName('User')
	testClass.setTitle('Mr.')
	testClass.setDateOfBirth('01/01/1901')
	testClass.setGender('male')
	testClass.setCountryName('USA')


	# Test that getters retrieve the set properties
	test.equal testClass.getFirstName(), 'Test'
	test.equal testClass.getLastName(), 'User'
	test.equal testClass.getTitle(), 'Mr.'
	test.equal testClass.getDateOfBirth(), '01/01/1901'
	test.equal testClass.getGender(), 'male'
	test.equal testClass.getCountryName(), 'USA'

	testObject = TestCollection.findOne({_id:testClass._id})

	test.equal testObject.firstName, 'Test'
	test.equal testObject.lastName, 'User'
	test.equal testObject.title, 'Mr.'
	# test.equal testObject.dateOfBirth, '01/01/1901'
	test.equal testObject.gender, 'male'

	tearDown()
	return

# Test using basic schema
Tinytest.add "ReactiveClassBase: properties and methods methods should not return private methods/properties", (test) ->
	setUp()
	test.equal (_.filter testClass.properties(), (item) -> item.indexOf('_') > 0).length, 0
	test.equal (_.filter testClass.methods(), (item) -> item.indexOf('_') > 0).length, 0
	tearDown()
	return

# Test using basic schema
Tinytest.add "ReactiveClassBase: properties method returns properties", (test) ->
	setUp()
	# testClass._new()
	testClass.setGender('male')
	test.equal testClass.properties()[0], 'gender'
	testObject = TestCollection.findOne({_id:testClass._id})
	test.equal testObject.gender, 'male'
	testClass.setGender('female')
	testObject = TestCollection.findOne({_id:testClass._id})
	test.equal testObject.gender, 'female'
	tearDown()
	return

# Test using basic schema
Tinytest.add "ReactiveClassBase: invoking the _new method creates an object in the Mongo collection", (test) ->
	setUp()
	# testClass._new()
	test.equal TestCollection.find().fetch().length, 1
	tearDown()
	return

# Test using basic schema
Tinytest.add "ReactiveClassBase: a newly created registers its collection id", (test) ->
	setUp()
	# testClass._new()
	collectionObject = TestCollection.find().fetch()[0]
	test.equal testClass._id, collectionObject._id
	tearDown()
	return

# Test using basic schema
Tinytest.add "ReactiveClassBase: an instance's delete method removes its' corresponding document from the database", (test) ->
	setUp()
	# testClass._new()
	test.equal TestCollection.find().fetch().length, 1
	collectionObject = TestCollection.find().fetch()[0]
	console.log collectionObject
	test.equal testClass._id, collectionObject._id
	testClass.delete()
	test.equal TestCollection.find().fetch().length, 0
	tearDown()
	return

# Test using basic schema

'''
Tinytest.add "An instance's delete method removes all methods and properties from the instance", (test) ->
	setUp()
	testClass._new()
	testClass.setFirstName("Test")
	testClass.setLastName("Case")
	console.log testClass
	test.equal testClass.methods().length, 5
	test.equal testClass.properties().length, 2

	testClass.delete()
	console.log testClass
	test.equal testClass.methods().length, 0
	test.equal testClass.properties().length, 0
	return
'''