({
  access: 'public',
  method: async ({ name }) => {
    const ctx = {
      pg: lib.db.connection,
      /*processId: new uuid,
        logger: new Logger(processId)*/
    };
    /*The following try catch should be extracted
      or even moved to system code*/
    try {
      const chat = await domain.Chat.get(ctx, name);
      return { status: 'fulfilled', value: { chat } };
    } catch (error) {
      return {
        status: 'rejected',
        reason: typeof error.toJSON === 'function' ? error.toJSON() : error,
      };
    }
  },
});
