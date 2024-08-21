import http from 'k6/http';

export default function () {
  const url = 'http://172.30.40.51:32490/hello';
  const payload = JSON.stringify({
    email: 'aaa',
    password: 'bbb',
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
      'lane': 'test-v1'
    },
  };

  http.post(url, payload, params);
}
