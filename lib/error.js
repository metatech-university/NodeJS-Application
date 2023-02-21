({
  SystemError: class SystemError extends Error {
    constructor(message, context) {
      super(message);
      this.name = 'SystemError';
      this.code = 500;
      this.context = context;
    }

    toJSON() {
      return {
        name: this.name,
        code: this.code,
        message: this.message,
        context: this.context,
        stack: this.stack,
      };
    }
  },
});
