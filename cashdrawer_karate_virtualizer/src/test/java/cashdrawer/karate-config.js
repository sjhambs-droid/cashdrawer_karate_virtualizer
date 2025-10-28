function fn() {
  var config = {};
  config.cashDrawerBaseUrl = 'http://localhost:8080';
  karate.configure('connectTimeout', 3000);
  karate.configure('readTimeout', 5000);
  return config;
}
