async (ctx, name) => {
  const {
    rows: [chat],
  } = ctx.state.pg.query(`SELECT * FROM "Chat" WHERE "name" = $1`, [name]);
  return chat;
};
