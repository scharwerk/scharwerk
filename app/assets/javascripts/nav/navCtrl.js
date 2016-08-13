angular.module('flapperNews')
.controller('NavCtrl', [
'$scope',
'Auth',
function($scope, Auth){
  $scope.signedIn = Auth.isAuthenticated;
  $scope.logout = Auth.logout;

  // not sure below is correct
  Auth.currentUser().then(function (user){
  	$scope.user = user;
  });
}]);
