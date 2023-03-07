({
  NotFoundError: class NotFoundError extends lib.error.SystemError {
    constructor(message, context) {
      super(message, context);
      this.name = 'NotFoundError';
      this.code = 404;
    }
  },
});
