({
  access: 'public',
  method: async ({ login, password }) => {
    console.log({ method: 'auth.signin', login, password });
    return { status: 'ok', token: '--no-token-provided--' };
  },
});
