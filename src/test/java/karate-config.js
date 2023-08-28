function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiurl: 'https://api.realworld.io/api/'
  }
  if (env == 'dev') {
    config.userEmail = "testmailoi@testmailoi.testmailoi"
    config.userPassword = "testmailoi"
  }  
  if (env == 'qa') {
    config.userEmail = "testmailoiqa@testmailoi.testmailoi"
    config.userPassword = "testmailoi"
  }

  var accessToken = karate.callSingle('classpath:conduitApp/helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;

}