import http from 'k6/http';

export default function () {
  const url = 'http://a6402dfe00a5542b69b8d6a18d9654ae-242407463.us-east-1.elb.amazonaws.com/hello';
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
