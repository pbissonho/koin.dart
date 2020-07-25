module.exports = {
  title: 'Koin.dart',
  tagline: 'A pragmatic lightweight dependency injection framework for Dart developers.',
  url: 'http://koindart.dev/',
  baseUrl: '/',
  favicon: 'img/favicon.ico',
  organizationName: 'Pedro Bissonho', // Usually your GitHub org/user name.
  projectName: 'Koin.dart', // Usually your repo name.
  themeConfig: {
    prism: {
      additionalLanguages: ["dart", "yaml"],
    },
    navbar: {
      title: 'Koin.dart',
      logo: {
        alt: 'koin.dart logo',
        src: 'img/logo.svg',
      },
      links: [
        {
          to: 'docs/',
          activeBasePath: 'docs',
          label: 'Docs',
          position: 'left',
        },
        {
          href: 'https://github.com/pbissonho/koin.dart',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Style Guide',
              to: 'docs/',
            },
            {
              label: 'Second Doc',
              to: 'docs/doc2/',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/koindart',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'Blog',
              to: 'blog',
            },
            {
              label: 'GitHub',
              href: 'https://github.com/pbissonho/koin.dart',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Koin team, Inc. Built with Docusaurus.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          // It is recommended to set document id as docs home page (`docs/` path).
          homePageId: 'home',
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl:
            'https://github.com/pbissonho/koin.dart/tree/master/website',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
