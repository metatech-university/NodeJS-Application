({
  access: 'public',
  method: async ({ login, password }) => {
    const user = await api.auth
      .provider()
      .getUser(login)
      .then((u) => u.rows[0]);
    if (!user) throw new Error('Incorrect login or password');
    const { id: accountId, password: hash } = user;
    const valid = await metarhia.metautil.validatePassword(password, hash);
    // regenerate all passwords for data.sql(msut comply with new hashing rules)
    if (!valid) throw new Error('Incorrect login or password');
    console.log(`Logged user: ${login}`);
    const token = api.auth.provider().generateToken();
    const data = { accountId: user.id };
    context.client.startSession(token, data);
    const { ip } = context.client;
    api.auth.provider().startSession(token, data, { ip, accountId });
    return { status: 'logged', token };
  },
});
