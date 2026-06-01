function fn() {
  var env = karate.env || 'dev';

  var config = {
    env: env,
    baseUrl: 'https://serverest.dev'
  };

  if (env === 'local') {
    config.baseUrl = 'http://localhost:3000';
  }

  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout',    30000);
  karate.configure('ssl', true);

  // ✅ FIX: monitor=false evita que ServeRest rechace requests por bot detection
  karate.configure('headers', {
    'Content-Type': 'application/json',
    'Accept':       'application/json',
    'monitor':      'false'
  });

  karate.log('=== Config | env:', env, '| baseUrl:', config.baseUrl, '===');
  return config;
}
