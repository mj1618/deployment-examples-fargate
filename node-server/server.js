'use strict';

const http = require('http');
const express = require('express');
const pg = require("pg");

// Constants
const HOST = '0.0.0.0';
const PORT = 8080;

// Database
const pool = new pg.Pool({
  user: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  database: "postgres",
  port: 5432,
  max: 200,
  connectionTimeoutMillis: 5000,
  application_name: "dxfar-node-server",
});

// App
const app = express();
app.get('/', (req, res) => {
  res.send(`Hello World!`);
});

app.get('/healthcheck', (req, res) => {
  res.send('ok');
});

app.get('/db-query-time', (req, res) => {
  pool.query('SELECT now() as current_time').then(result => {
    res.json(result.rows[0]);
  });
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
