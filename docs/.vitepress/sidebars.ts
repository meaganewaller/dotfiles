import menus from "./menus";

export const documentation = [
  {
    items: [
      { text: "Overview", link: "/" },
      { text: "Getting Started", link: "/getting-started" },
    ]
  },
  menus.features,
  menus.reference,
  menus.settingsReference,
  menus.misc,
  menus.sourceCode,
];

export const info = [menus.main];

export default {
  info, documentation
}

