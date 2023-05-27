async () => {
  console.info('Connect to PG');
  domain.pg = new db.pg.Pool(config.database);
};
