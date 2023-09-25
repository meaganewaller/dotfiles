window.$docsify = {
  name: "meagan's dotfiles",
  repo: 'https://github.com/meaganewaller/dotfiles',
  formatUpdated: '{MM}/{DD} {HH}:{mm}',
  loadFooter: true,
  loadSidebar: true,
  search: {
    placeholder: 'find something...',
  },
  subMaxLevel: 4,
  auto2top: true,
  autoHeader: true,
  nativeEmoji: true,
  routerMode: 'history',
  alias: {
    '/.*/_sidebar.md': '/_sidebar.md',
  },
  copyCode: {
    buttonText: 'Copy',
    errorText: 'Error',
    successText: 'Copied',
  },
  pagination: {
    crossChapter: true,
    crossChapterText: true,
  },
};
