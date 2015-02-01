Package.describe({
  name: 'peter:collection-class',
  version: '0.0.2',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: 'https://github.com/siegesmund/meteor-reactive-class',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3.1');
  api.use(['coffeescript', 'underscore', 'accounts-base', 'accounts-password']);
  api.use(['aldeed:collection2@2.3.1', 'aldeed:simple-schema@1.3.0', 'alanning:roles@1.2.13']);
  api.addFiles(['src/collection-class.coffee', 'src/user-class.coffee'], ['client','server']);
  api.export(['CollectionClass', 'User']);
});

Package.onTest(function(api) {
  api.use(['coffeescript','underscore','tinytest', 'test-helpers', 'accounts-base', 'accounts-password']);
  api.use(['aldeed:collection2@2.3.1', 'aldeed:simple-schema@1.3.0', 'alanning:roles@1.2.13']);
  api.use('peter:collection-class');
  api.addFiles(['tests/peter:collection-class-test-schema.coffee', 'tests/peter:collection-class-tests.coffee']);
  api.export(['CollectionClass', 'User']);
});