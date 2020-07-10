
module.exports = {
  docs: [
    {
      type: 'category',
      label: 'Koin.dart',
      items: ['home', 'setup', 'resources','support'],
    },
    {
      type: 'category',
      label: 'Koin in 5 minutes',
      collapsed: false,
      items: [
        'start/quickstart/dart',
        'start/quickstart/flutter',
        'start/quickstart/test',
      ],
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
            'reference/koin-flutter/start',
            'reference/koin-flutter/scope',
            'reference/koin-flutter/get-instances',
          ],

          Test: [
            'reference/koin-test/testing',
          ],
        },
      ],
    },
    {
      type: 'category',
      label: 'Examples',
      items: ['examples'],
    },
  ],
};
