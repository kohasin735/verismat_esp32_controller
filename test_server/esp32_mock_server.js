/**
 * VeriSmat ESP32 Mock Server
 * Simulates the ESP32 educational board's Wi-Fi HTTP API
 * 
 * Endpoints:
 * - GET  /api/status
 * - POST /api/select
 * - POST /api/execute
 * - POST /api/stop
 */

const http = require('http');

const PORT = process.env.PORT || 8080;

const projectNames = {
  1: {
    1: 'Push and Glow Board',
    2: 'LED Pattern Board',
    3: 'Sound Alert Box',
    4: 'Colour Light Selector',
    5: 'Traffic Light Model',
    6: 'Rain Alert System'
  },
  2: {
    1: 'Smart Night Lamp',
    2: 'Motion Alert System',
    3: 'Temperature Indicator',
    4: 'Digital Counter Model',
    5: 'Password Entry System',
    6: 'Touch Music Panel'
  },
  3: {
    1: 'Smart Room Monitor',
    2: 'Distance Measurement System',
    3: 'Water Level Indicator',
    4: 'Automated Gate System',
    5: 'Smart Switch',
    6: 'Sensor Status Dashboard'
  },
  4: {
    1: 'Servo Controlled Gate Model',
    2: 'Smart Parking Indicator System',
    3: 'Event-Based Intrusion Recorder',
    4: 'Smart Energy Saving System',
    5: 'Magnetic Door Status Monitor',
    6: 'Laser Tripwire Security System'
  }
};

let state = {
  wifi: true,
  ssid: "VeriSmat-ESP32",
  ip: "192.168.4.1",
  grade: 0,
  project: 0,
  running: false,
  projectName: null
};

const server = http.createServer((req, res) => {
  // Allow CORS headers for debugging/testing
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  res.setHeader('Content-Type', 'application/json');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const url = req.url.split('?')[0];

  console.log(`[ESP32] ${req.method} ${url}`);

  if (req.method === 'GET' && url === '/api/status') {
    res.writeHead(200);
    res.end(JSON.stringify(state, null, 2));
    return;
  }

  if (req.method === 'POST') {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });

    req.on('end', () => {
      if (url === '/api/select') {
        try {
          const parsed = body ? JSON.parse(body) : {};
          const grade = parseInt(parsed.grade, 10);
          const project = parseInt(parsed.project, 10);

          if (!grade || !project || grade < 1 || grade > 4 || project < 1 || project > 6) {
            res.writeHead(400);
            res.end(JSON.stringify({ ok: false, error: 'Invalid grade or project number' }));
            return;
          }

          state.grade = grade;
          state.project = project;
          state.running = false;
          state.projectName = (projectNames[grade] && projectNames[grade][project]) || `Project ${project}`;

          console.log(`[ESP32] Project Selected: Grade ${grade} - ${state.projectName}`);

          res.writeHead(200);
          res.end(JSON.stringify({ ok: true, grade: state.grade, project: state.project, projectName: state.projectName }));
        } catch (err) {
          res.writeHead(400);
          res.end(JSON.stringify({ ok: false, error: 'Malformed JSON body' }));
        }
        return;
      }

      if (url === '/api/execute') {
        state.running = true;
        console.log(`[ESP32] EXECUTE: Started project ${state.projectName || 'None'}`);
        res.writeHead(200);
        res.end(JSON.stringify({ ok: true, running: true }));
        return;
      }

      if (url === '/api/stop') {
        state.running = false;
        console.log(`[ESP32] STOP: Stopped project ${state.projectName || 'None'}`);
        res.writeHead(200);
        res.end(JSON.stringify({ ok: true, running: false }));
        return;
      }

      res.writeHead(404);
      res.end(JSON.stringify({ error: 'Not Found' }));
    });
    return;
  }

  res.writeHead(404);
  res.end(JSON.stringify({ error: 'Not Found' }));
});

server.listen(PORT, () => {
  console.log(`====================================================`);
  console.log(`VeriSmat ESP32 Mock Server running on port ${PORT}`);
  console.log(`Simulation Target: http://192.168.4.1 (or http://localhost:${PORT})`);
  console.log(`Available Endpoints:`);
  console.log(`  GET  /api/status`);
  console.log(`  POST /api/select  {"grade": 2, "project": 3}`);
  console.log(`  POST /api/execute`);
  console.log(`  POST /api/stop`);
  console.log(`====================================================`);
});
