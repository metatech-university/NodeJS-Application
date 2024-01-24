({
  generateToken() {
    const { characters, secret, length } = config.sessions;
    return common.generateToken(secret, characters, length);
  },

  saveSession(token, data) {
    return db('Session').update(token, { data: JSON.stringify(data) });
  },

  startSession(token, data, fields = {}) {
    const record = { token, data: JSON.stringify(data), ...fields };
    return db('Session').create(record);
  },

  async restoreSession(token) {
    const record = await db('Session').read(token, 'token', ['data']);
    if (record && record.data) return record.data;
    return null;
  },

  deleteSession(token) {
    return db('Session').delete(token, 'token');
  },

  async registerUser(login, password) {
    return db('Account').create({ login, password });
  },

  async getUser(login) {
    return db('Account')
      .read(login, 'login')
      .then((u) => u.rows[0]);
  },
});
