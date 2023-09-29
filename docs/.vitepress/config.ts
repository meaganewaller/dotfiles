import { defineConfig } from "vitepress";

export default defineConfig({
  title: "meaganewaller/dotfiles",
  description: "my dotfiles - where cuteness & productivity are prioritized.",
  base: process.env.BASE_URL || "/",
  lang: "en-US",
  lastUpdated: true,
  cleanUrls: true,
  appearance: "light",
  titleTemplatee: ":title • meaganewaller/dotfiles",
  head: [
    ["meta", { name: "theme-color", content: "#FFD1DC" }],
    ["meta", { name: "og:type", content: "website" }],
    ["meta", { name: "og:locale", content: "en" }],
  ],
  themeConfig: {
    nav: [
      {
        text: "Discussions",
        link: "https://github.com/meaganewaller/dotfiles/discussions",
      },
      {
        text: "Issues",
        link: "https://github.com/meaganewaller/dotfiles/issues",
      },
    ],
    sidebar: [
      {
        items: [
          { text: "Overview", link: "/" },
          { text: "Getting started", link: "/getting-started" },
          { text: "Installation", link: "/installation" },
          { text: "Gallery", link: "/gallery" },
        ],
      },
      {
        text: "🧰 tools",
        collapsible: true,
        collapsed: true,
        items: [
          { text: "asdf", link: "/features/asdf" },
          { text: "fish shell", link: "/features/fish-shell" },
          { text: "hammerspoon", link: "/features/hammerspoon" },
          { text: "homebrew", link: "/features/homebrew" },
          { text: "karabiner", link: "/features/karabiner" },
          { text: "kitty", link: "/features/kitty" },
          { text: "neovim", link: "/features/neovim" },
          { text: "sketchybar", link: "/features/sketchybar" },
          { text: "skhd", link: "/features/skhd" },
          { text: "yabai", link: "/features/yabai" },
        ],
      },
      {
        text: "🧭 guides",
        collapsible: true,
        collapsed: true,
        items: [
          {
            text: "keyboard-driven workflows",
            link: "/guides/keyboard-driven-workflows",
          },
          {
            text: "managing windows with yabai",
            link: "/guides/managing-windows-with-yabai",
          },
        ],
      },
      {
        text: "🙋 help & support",
        collapsible: true,
        collapsed: false,
        items: [
          {
            text: "getting help",
            link: "/help/",
          },
          {
            text: "faq",
            link: "/help/faq",
          },
        ],
      },
    ],
    search: {
      provider: "local",
    },
    docFooter: { next: false, prev: false },
    socialLinks: [
      { icon: "github", link: "https://github.com/meaganewaller/dotfiles" },
      {
        icon: "twitter",
        link: "https://twitter.com/meaganewaller",
      },
      {
        icon: "linkedin",
        link: "https://linkedin.com/u/meaganewaller",
      },
    ],
  },
});
