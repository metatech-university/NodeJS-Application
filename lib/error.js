({
  SystemError: class SystemError extends Error {
    constructor(message, context) {
      super(message);
      this.name = 'SystemError';
      this.code = 500;
      this.context = context;
    }

    toJSON() {
      const { name, code, message, context, stack } = this;
      return { name, code, message, context, stack };
    }
  },
});
