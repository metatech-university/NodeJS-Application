({
  Registry: {},

  name: { type: 'string', unique: true },
  kind: {
    enum: [
      'entity',
      'registry',
      'dictionary',
      'journal',
      'details',
      'relation',
      'view',
      'form',
      'projection',
    ],
    default: 'entity',
  },
});
