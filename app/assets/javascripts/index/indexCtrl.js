angular.module('scharwerk')
.controller('IndexCtrl', [
'$scope',
'ezfb',
'$http',
'Auth',
function($scope, ezfb, $http, Auth){
	function fbLogin(response) {
    $http.post('/login', response.authResponse).then(function successCallback(response) {
      Auth._currentUser = response.data;
      $scope.$broadcast('devise:login', response.data);
    }, function errorCallback(response) {
      // called asynchronously if an error occurs
      // or server returns response with an error status.
    });
	}
	$scope.login = function() {
		ezfb.getLoginStatus(function (response) {
			if (response.status !== 'connected') {
            	ezfb.login(fbLogin);
            	return ;  
          	} 
          	fbLogin(response)
  		});
	};
  $scope.isAuthenticated = Auth.isAuthenticated();
  $scope.$on('devise:login', function(event, currentUser) {
    $scope.isAuthenticated = true;
  });
}]);