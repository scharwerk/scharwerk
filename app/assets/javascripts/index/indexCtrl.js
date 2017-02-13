angular.module('scharwerk')
.controller('IndexCtrl', [
'$scope',
'$state',
'authentication',
'stages',
'tasks',
function($scope, $state, authentication, stages, tasks){

  $scope.login =  authentication.login; 
  $scope.logout = authentication.logout;
  
  $scope.isAuthenticated = false;

  $scope.$on('devise:logout', function (e, user){ 
    $scope.user = {}; 
    $scope.isAuthenticated = false;
  });
  $scope.$on('devise:login', function (e, user){ 
    $scope.isAuthenticated = true;
    $scope.user = user; 
    tasks.updateCurrent();
  });

  
  authentication.currentUser().then(function (user){ 
    $scope.isAuthenticated = true;
    $scope.user = user; 
    tasks.updateCurrent();
  });

  $scope.release = tasks.release;
  $scope.assign = function(stage) {
    tasks.assign(stage).success(function () {
      $state.go('proof');
    });
  };

  // top list
  $scope.topList = 'Завантаження...';
  $scope.goingList = 'Завантаження...';
  stages.getTop(function(top, going) {
    $scope.topList = top;
    $scope.goingList = going;    
  });

  $scope.task = tasks.current;
  $scope.graphs = stages.graphs;

  $scope.debug = (window.location.hash.indexOf('debug') !== -1);
  $scope.options = {thickness: 16.5, mode: 'gauge', total: 100};
  $scope.optionsSmall = {thickness: 12, mode: 'gauge', total: 100};
  $scope.data  = [{label: "Завершено", value: 75, suffix: '%', colorComplement: '#FFFFFF', color: '#FFC107'}];
  $scope.dataDone  = [{label: "Завершено", value: 100, suffix: '%', color: '#4CAF50'}];
  $scope.dataNone  = [{label: "Завершено", value: 0, suffix: '%', color: '#212121', colorComplement: '#212121'}];
}]);