({
  host: '0.0.0.0',
  balancer: 8000,
  protocol: 'http',
  ports: [8001],
  nagle: false,
  cors: {
    origin: '*',
  },
});
