import { defineConfig } from 'vitepress'
import * as navbars from './navbars'
import * as sidebars from './sidebars'

export default defineConfig({
  title: 'meaganewaller/dotfiles',
  description: 'My personal dotfiles',
  lastUpdated: true,
  locales: {
    root: {
      label: 'English',
      lang: 'en-US',
      themeConfig: {
        nav: navbars.en,
        sidebar: sidebars.en,
      },
    },
  },
  themeConfig: {
    search: {
      provider: "local",
    },
    socialLinks: [
      {
        icon: 'github',
        link: 'https//github.com/meaganewaller/dotfiles'
      },
      {
        icon: 'twitter',
        link: 'https://twitter.com/meaganewaller'
      },
    ],
  },
})
