async (name) => {
  const sql = 'SELECT * FROM "Chat" WHERE "name" = $1';
  const { rows: [chat] } = await domain.pg.query(sql, [name]);
  return chat;
};
