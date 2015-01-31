Package.describe({
  name: 'peter:reactive-class',
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
  api.use(['coffeescript', 'underscore']);
  api.use(['aldeed:collection2@2.3.1', 'aldeed:simple-schema@1.3.0', 'alanning:roles@1.2.13']);
  api.addFiles(['src/reactive-class-base.coffee'], ['client','server']);
  api.export(['ReactiveClassBase']);
});

Package.onTest(function(api) {
  api.use(['coffeescript','underscore', 'tinytest']);
  api.use(['aldeed:collection2@2.3.1', 'aldeed:simple-schema@1.3.0', 'alanning:roles@1.2.13']);
  api.use('peter:reactive-class');
  api.addFiles(['tests/peter:reactive-class-test-schema.coffee', 'tests/peter:reactive-class-tests.coffee', 'tests/peter:reactive-user-tests.coffee']);
  api.export(['ReactiveClassBase']);
});