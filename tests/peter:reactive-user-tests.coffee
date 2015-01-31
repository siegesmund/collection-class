'''
Tinytest.add "Create a ReactiveUser instance", (test) ->
	testUser = new ReactiveUser()
	test.notEqual testUser, undefined
	return

Tinytest.add "When an instance is created, getters and setters are created", (test) ->
	testClass = new ReactiveClassBase(TestCollection)
	test.notEqual testClass.getFirstName, undefined
	test.notEqual testClass.getEmails, undefined
	test.notEqual testClass.setOrganization, undefined
	#test.notEqual testClass.setAddress, undefined    ## Will break as long as list properties are disabled
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

Tinytest.add "schema enforces that properties can only be updated with the correct properties", (test) ->
	testClass = new ReactiveClassBase(TestCollection)
	# testClass.setFirstName(0)
	# test.equal testClass.getFirstName(), undefined
	return
'''