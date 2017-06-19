angular.module('scharwerk')
.factory('authentication', [
'Auth',
'$rootScope',
'$http',
'ezfb',
function(Auth, $rootScope, $http, ezfb){
  function fbLogin(response) {
    $http.post('/login', response.authResponse).then(function successCallback(response) {
      Auth._currentUser = response.data;
      $rootScope.$broadcast('devise:login', response.data);
    }, function errorCallback(response) {
      // called asynchronously if an error occurs
      // or server returns response with an error status.
    });
  };

  var s = {};

  s.login = function() {
    ezfb.getLoginStatus(function (response) {
      if (response.status !== 'connected') {
        ezfb.login(fbLogin);
        return ;  
      } 
      fbLogin(response)
    });  	
  };

  s.autologin = function() {
    s.login();
    if (!s.isAuthenticated) {
      s.autologin();
    }
  }

  s.logout = Auth.logout;
  s.currentUser = Auth.currentUser;
  s.isAuthenticated = Auth.currentUser;
  return s;
}]);