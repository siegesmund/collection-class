

testClass = undefined

tearDown = ->
	TestCollection.remove({})
	testClass = undefined

setUp = ->
	testClass = new ReactiveClassBase(TestCollection)



Tinytest.add "Create a ReactiveClassBase instance", (test) ->
	setUp()
	test.notEqual testClass, undefined
	tearDown()
	return

# Test using basic schema
Tinytest.add "When an instance is created, getters and setters are created", (test) ->
	setUp()
	test.notEqual testClass.getFirstName, undefined
	tearDown()
	return

# Test using basic schema
Tinytest.add "Set and get a nested string method", (test) ->
	setUp()
	testClass.setFirstName('Test')
	testClass.setLastName('User')
	test.equal testClass.getFirstName(), 'Test'
	test.equal testClass.getLastName(), 'User'
	tearDown()
	return

# Test using basic schema
Tinytest.add "Properties and methods methods should not return private methods/properties", (test) ->
	setUp()
	test.equal (_.filter testClass.properties(), (item) -> item.indexOf('_') > 0).length, 0
	test.equal (_.filter testClass.methods(), (item) -> item.indexOf('_') > 0).length, 0
	tearDown()
	return

# Test using basic schema
Tinytest.add "Properties method returns properties", (test) ->
	setUp()
	testClass.setGender('male')
	test.equal testClass.properties()[0], 'gender'
	tearDown()
	return

# Test using basic schema
Tinytest.add "Invoking the _new method creates an object in the Mongo collection", (test) ->
	setUp()
	testClass._new()
	test.equal TestCollection.find().fetch().length, 1
	tearDown()
	return

# Test using basic schema
Tinytest.add "A newly created registers its collection id", (test) ->
	setUp()
	testClass._new()
	collectionObject = TestCollection.find().fetch()[0]
	test.equal testClass._id, collectionObject._id
	tearDown()
	return

# Test using basic schema
Tinytest.add "An instance's delete method removes its' corresponding document from the database", (test) ->
	setUp()
	testClass._new()
	test.equal TestCollection.find().fetch().length, 1
	collectionObject = TestCollection.find().fetch()[0]
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