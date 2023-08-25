const Consul = require('consul');
const express = require('express');

const SERVICE_NAME = process.env.microservice_name;
const HOST = process.env.private_ip;
const SERVICE_ID='m'+process.argv[2]+'-'+process.env.service_id;
const SCHEME='http';
const PORT= process.argv[2]*1;
const PID = process.pid;

const CONSUL_HOST = process.env.consul_ip; 
const CONSUL_PORT = 8500;

/* Inicialización del servidor Express */
const app = express();
const consul = new Consul({ host: CONSUL_HOST, port: CONSUL_PORT }); // Configura el agente de Consul

app.get('/health', function (req, res) {
    console.log('Health check!');
    res.end("Ok.");
});

app.get('/', (req, res) => {
    console.log('GET /', Date.now());
    res.json({
        data: Math.floor(Math.random() * 89999999 + 10000000),
        data_pid: PID,
        data_service: SERVICE_ID,
        data_host: HOST
    });
});

app.listen(PORT, function () {
    console.log('Servicio iniciado en:' + SCHEME + '://' + HOST + ':' + PORT + '!');
});

/* Registro del servicio */
var check = {
    id: SERVICE_ID,
    name: SERVICE_NAME,
    address: HOST,
    port: PORT,
    check: {
        http: SCHEME + '://' + HOST + ':' + PORT + '/health',
        ttl: '5s',
        interval: '5s',
        timeout: '5s',
        deregistercriticalserviceafter: '1m'
    }
};

consul.agent.service.register(check, function (err) {
    if (err) throw err;
});