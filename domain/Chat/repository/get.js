async (ctx, name) => {
  const {
    rows: [chat],
  } = ctx.pg.query(`SELECT * FROM "Chat" WHERE "name" = $1`, [name]);
  return chat;
};
