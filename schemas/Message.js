({
  Entity: {},

  thread: { type: 'Message', required: false }, // Link to a 'parent' message

  chat: 'Chat',
  area: 'Area',
  from: 'Account',

  data: {
    type: 'json',
    schema: {
      kind: { enum: ['text', 'image', 'video', 'file'] },
      media: { array: 'string', required: false },
      text: { type: 'string', required: false }
    },
  },
});
