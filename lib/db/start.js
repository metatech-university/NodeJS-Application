async () => {
  if (application.worker.id === 'W1') {
    console.info('Connecting to pg...');
  }
  const options = {
    ...config.database,
    console,
    model: application.schemas.model,
  };
  const database = new metarhia.metasql.Database(options);

  lib.db.connection = database;
  application.emit('bootstrap-db');

  if (application.worker.id === 'W1') {
    const {
      rows: [{ now }],
    } = await lib.db.connection.query(`SELECT now()`);
    console.info(`Connected to pg at ${new Date(now).toLocaleTimeString()}`);
  }
};
