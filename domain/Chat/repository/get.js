async (ctx, name) => {
  const sql = `SELECT * FROM "Chat" WHERE "name" = $1`;
  const { rows: [chat] } = ctx.state.pg.query(sql, [name]);
  return chat;
};
