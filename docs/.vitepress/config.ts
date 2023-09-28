import wikilinks from "markdown-it-wikilinks";
import { type DefaultTheme, type HeadConfig, defineConfig } from 'vitepress'
import * as navbars from './navbars';
import * as sidebars from './sidebars';

const head: HeadConfig[] = [
  [
    'link',
    {
      rel: 'prefetch',
      as: 'style',
      type: 'text/css;charset=utf-8',
      href: 'https://cdn.jsdelivr.net/npm/@typehaus/metropolis/index.css',
      crossorigin: 'anonymous',
    },
  ],
  [
    'link',
    {
      rel: 'prefetch',
      as: 'icon',
      type: 'image/svg+xml;charset=utf-8',
      href: '/favicon.svg',
    },
  ],
  [
    'link',
    {
      rel: 'icon',
      type: 'image/svg+xml;charset=utf-8',
      href: '/favicon.svg',
    },
  ],
  [
    'link',
    {
      rel: 'stylesheet',
      type: 'text/css;charset=utf-8',
      href: 'https://cdn.jsdelivr.net/npm/@typehaus/metropolis/index.css',
      crossorigin: 'anonymous',
    },
  ],
  [
    'link',
    {
      rel: 'mask-icon',
      type: 'image/svg+xml;charset=utf-8',
      href: '/favicon.svg',
      color: '#112233',
    },
  ],
  [
    'meta',
    {
      name: 'theme-color',
      content: '#112233',
      value: '#112233',
    },
  ],
]

const nav: DefaultTheme.NavItem[] = [
  {
    text: 'Issues',
    target: '_blank',
    rel: 'noopener',
    ariaLabel: 'GitHub Issue Tracker',
    link: 'https://github.com/meaganewaller/dotfiles/issues',
  },
  {
    text: 'Discussions',
    target: '_blank',
    rel: 'noopener',
    ariaLabel: 'GitHub Discussions',
    link: 'https://github.com/meaganewaller/dotfiles/discussions',
  },
]

export default defineConfig({
  lang: 'en-US',
  title: 'meaganewaller/dotfiles',
  description: 'the dotfiles that make my machines cute and functional',
  base: '/',
  head,
  themeConfig: {
    nav,
    logo: '/favicon.svg',
    repo: 'meaganewaller/dotfiles',
    docsDir: 'docs',
    docsBranch: 'main',
    editLinks: true,
    editLinkText: 'Edit on GitHub',
    lastUpdated: true,
    prevLinks: true,
    nextLinks: true,
  } as DefaultTheme.Config,
});
