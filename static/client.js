'use strict';

const transport = {};

let callId = 1;

transport.http = (url) => (structure) => {
  const api = {};
  const services = Object.keys(structure);
  for (const name of services) {
    api[name] = {};
    const service = structure[name];
    const methods = Object.keys(service);
    for (const methodName of methods) {
      api[name][methodName] = (...values) =>
        new Promise((resolve, reject) => {
          const id = callId++;
          const entries = structure[name][methodName].map((key, index) => {
            return [key, values[index]];
          });
          const args = Object.fromEntries(entries);
          const method = name + '/' + methodName;
          const packet = { type: 'call', id, method, args };
          fetch(url + '/api', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(packet),
          }).then((res) => {
            if (res.status === 200) resolve(res.json());
            else reject(new Error(`Status Code: ${res.status}`));
          });
        });
    }
  }
  return Promise.resolve(api);
};

transport.ws = (url) => (structure) => {
  const socket = new WebSocket(url);
  const api = {};
  const services = Object.keys(structure);
  for (const name of services) {
    api[name] = {};
    const service = structure[name];
    const methods = Object.keys(service);
    for (const methodName of methods) {
      api[name][methodName] = (...values) =>
        new Promise((resolve) => {
          const id = callId++;
          const entries = structure[name][methodName].map((key, index) => {
            return [key, values[index]];
          });
          const args = Object.fromEntries(entries);
          const method = name + '/' + methodName;
          const packet = { type: 'call', id, method, args };
          socket.send(JSON.stringify(packet));
          socket.onmessage = (event) => {
            const data = JSON.parse(event.data);
            resolve(data);
          };
        });
    }
  }
  return new Promise((resolve) => {
    socket.addEventListener('open', () => resolve(api));
  });
};

const scaffold = (url) => {
  const protocol = url.startsWith('ws:') ? 'ws' : 'http';
  return transport[protocol](url);
};

(async () => {
  const api = await scaffold('ws://localhost:8001')({
    auth: {
      signin: ['login', 'password'],
      signout: [],
      restore: ['token'],
    },
    messenger: {
      method: ['arg'],
    },
  });
  const data = await api.auth.signin('marcus', 'marcus');
  console.dir({ data });
})();
