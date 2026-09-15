/**
 * Automated test script to verify ESP32 API contract
 */

const http = require('http');

const PORT = process.env.PORT || 8080;
const HOST = '127.0.0.1';

function request(method, path, body = null) {
  return new Promise((resolve, reject) => {
    const postData = body ? JSON.stringify(body) : '';
    const options = {
      hostname: HOST,
      port: PORT,
      path: path,
      method: method,
      headers: {
        'Content-Type': 'application/json',
        ...(postData ? { 'Content-Length': Buffer.byteLength(postData) } : {})
      }
    };

    const req = http.request(options, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => {
        try {
          resolve({ status: res.statusCode, body: JSON.parse(data) });
        } catch (e) {
          resolve({ status: res.statusCode, body: data });
        }
      });
    });

    req.on('error', reject);
    if (postData) req.write(postData);
    req.end();
  });
}

async function runTests() {
  console.log('--- Starting ESP32 API Contract Verification ---');

  // Test 1: GET /api/status (Initial)
  console.log('1. Testing GET /api/status...');
  let res = await request('GET', '/api/status');
  console.log('Response:', res);
  if (res.status !== 200 || res.body.wifi !== true || res.body.ip !== '192.168.4.1') {
    throw new Error('Initial status check failed');
  }
  console.log('PASS: GET /api/status\n');

  // Test 2: POST /api/select (Grade 2, Project 3: Temperature Indicator)
  console.log('2. Testing POST /api/select (Grade 2, Project 3)...');
  res = await request('POST', '/api/select', { grade: 2, project: 3 });
  console.log('Response:', res);
  if (res.status !== 200 || res.body.ok !== true || res.body.projectName !== 'Temperature Indicator') {
    throw new Error('Select project failed');
  }
  console.log('PASS: POST /api/select\n');

  // Test 3: POST /api/execute
  console.log('3. Testing POST /api/execute...');
  res = await request('POST', '/api/execute');
  console.log('Response:', res);
  if (res.status !== 200 || res.body.ok !== true || res.body.running !== true) {
    throw new Error('Execute project failed');
  }
  console.log('PASS: POST /api/execute\n');

  // Test 4: Verify status reflects running = true
  console.log('4. Verifying status reflects running = true...');
  res = await request('GET', '/api/status');
  console.log('Response:', res);
  if (res.body.running !== true || res.body.grade !== 2 || res.body.project !== 3) {
    throw new Error('Status did not reflect running state');
  }
  console.log('PASS: Status state synchronization\n');

  // Test 5: POST /api/stop
  console.log('5. Testing POST /api/stop...');
  res = await request('POST', '/api/stop');
  console.log('Response:', res);
  if (res.status !== 200 || res.body.ok !== true || res.body.running !== false) {
    throw new Error('Stop project failed');
  }
  console.log('PASS: POST /api/stop\n');

  // Test 6: Verify status reflects running = false
  console.log('6. Verifying status reflects running = false...');
  res = await request('GET', '/api/status');
  console.log('Response:', res);
  if (res.body.running !== false) {
    throw new Error('Status did not reflect stopped state');
  }
  console.log('PASS: Stopped state synchronization\n');

  console.log('====================================================');
  console.log('ALL API CONTRACT TESTS PASSED SUCCESSFULLY (6/6)');
  console.log('====================================================');
}

runTests().catch(err => {
  console.error('TEST FAILED:', err);
  process.exit(1);
});
