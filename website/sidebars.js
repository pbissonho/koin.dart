
module.exports = {
  docs: [
    {
      type: 'category',
      label: 'Koin.dart',
      items: ['home', 'setup', 'resources', 'examples', 'support'],
    },
    {
      type: 'category',
      label: 'Getting Started',
      collapsed: false,
      items: [
        'start/getting-started/starting-koin',
        'start/getting-started/koin-components',
        'start/getting-started/koin-for-flutter',
        'start/getting-started/modules-definitions',
        'start/getting-started/testing',
      ],
    },
    {
      Reference: [
        {
          Core: [
            'reference/koin-core/dsl',
            'reference/koin-core/definitions',
            'reference/koin-core/modules',
            'reference/koin-core/start-koin',
            'reference/koin-core/koin-component',
            'reference/koin-core/injection-parameters',
            'reference/koin-core/scopes',
            'reference/koin-core/logging',
            'reference/koin-core/properties',
            'reference/koin-core/setters',
          ],
          Flutter: [
            'reference/koin-flutter/dsl',
          ],

          Test: [
            'reference/koin-test/testing',
          ],
        },
      ],
    },
  ],
};
