
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
      collapsed: true,
      items: [
        'start/quickstart/dart',
        'start/quickstart/flutter',
        'start/quickstart/test',
      ],
    },
    {
      type: 'category',
      label: 'Getting Started',
      collapsed: true,
      items: [
        'start/getting-started/starting-koin',
        'start/getting-started/modules-definitions',
        'start/getting-started/koin-components',
        'start/getting-started/testing',
        'start/getting-started/koin-for-flutter',
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
          ],
          Flutter: [
            'reference/koin-flutter/start',
            'reference/koin-flutter/scope',
            'reference/koin-flutter/get-instances',
            'reference/koin-flutter/bloc',
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
      items: ['flutter_examples'],
    },
  ],
};
