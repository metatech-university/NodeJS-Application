({
  access: 'public',
  method: async ({ name }) => {
    context.state = { pg: lib.db.connection };

    try {
      const chat = await domain.Chat.get(context, name);
      return { status: 'fulfilled', value: { chat } };
    } catch (error) {
      return {
        status: 'rejected',
        reason: typeof error.toJSON === 'function' ? error.toJSON() : error,
      };
    }
  },
});
