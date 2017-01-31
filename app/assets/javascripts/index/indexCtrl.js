angular.module('scharwerk')
.controller('IndexCtrl', [
'$scope',
'$state',
'ezfb',
'stages',
'tasks',
'$http',
'Auth',
function($scope, $state, ezfb, stages, tasks, $http, Auth){

  function fbLogin(response) {
    $http.post('/login', response.authResponse).then(function successCallback(response) {
      Auth._currentUser = response.data;
      $scope.$broadcast('devise:login', response.data);
    }, function errorCallback(response) {
      // called asynchronously if an error occurs
      // or server returns response with an error status.
    });
  };

  $scope.login = function() {
    ezfb.getLoginStatus(function (response) {
      if (response.status !== 'connected') {
              ezfb.login(fbLogin);
              return ;  
            } 
            fbLogin(response)
      });
  };

  $scope.release = tasks.release;
  $scope.assign = function(stage) {
    tasks.assign(stage).success(function () {
      $state.go('proof');
    });
  };

  $scope.logout = Auth.logout;
  $scope.isAuthenticated = Auth.isAuthenticated;
  Auth.currentUser().then(function (user){ 
    $scope.user = user; 
    tasks.updateCurrent();
  });
  $scope.$on('devise:login', function (e, user){ 
    $scope.user = user; 
    tasks.updateCurrent();
  });
  $scope.$on('devise:logout', function (e, user){ $scope.user = {}; });

  $scope.task = tasks.current;
  $scope.graphs = stages.graphs;

  $scope.debug = (window.location.hash.indexOf('debug') !== -1);
  $scope.options = {thickness: 16.5, mode: 'gauge', total: 100};
  $scope.optionsSmall = {thickness: 12, mode: 'gauge', total: 100};
  $scope.data  = [{label: "Завершено", value: 75, suffix: '%', colorComplement: '#FFFFFF', color: '#FFC107'}];
  $scope.dataDone  = [{label: "Завершено", value: 100, suffix: '%', color: '#4CAF50'}];
  $scope.dataNone  = [{label: "Завершено", value: 0, suffix: '%', color: '#212121', colorComplement: '#212121'}];
}]);