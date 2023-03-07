({
  Entity: {},

  thread: { type: 'Message', required: false }, // Link to a 'parent' message

  chat: 'Chat',
  area: 'Area',
  from: 'Account',

  /* {
    kind: 'text' | 'image' | 'video' | 'file'
    media?: string[], // urls of images, files, videos
    text?: string
  } */
  data: { type: 'json' },
});
