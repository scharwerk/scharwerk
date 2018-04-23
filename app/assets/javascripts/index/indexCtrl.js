angular.module('scharwerk')
.controller('IndexCtrl', [
'$sce',
'$scope',
'$window',
'authentication',
'stages',
'tasks',
'$modal',
function($sce, $scope, $window, authentication, stages, tasks, $modal){

  // hack for fb app
  isFacebook = window.location.pathname.includes('/fb');
  $scope.isFacebook = isFacebook;

  if (isFacebook){
    authentication.login(); 
  }

  $scope.login =  authentication.login; 
  $scope.logout = authentication.logout;
  
  $scope.isAuthenticated = false;

  var updateTop = function () {
    stages.getUsers(function(data) {
      $scope.top = data.top;
      $scope.usersCount = data.users;
      $scope.current = data.current;
      $scope.avg = Math.round(data.total / data.top.length);
    });
  };
  updateTop();

  $scope.$on('devise:logout', function (e, user){ 
    $scope.user = {}; 
    $scope.isAuthenticated = false;
  });

  $scope.$on('devise:login', function (e, user){ 
    $scope.isAuthenticated = true;
    $scope.user = user; 
    tasks.updateCurrent();
    updateTop();
  });

  authentication.currentUser().then(function (user){ 
    $scope.isAuthenticated = true;
    $scope.user = user; 
    tasks.updateCurrent();
  });

  $scope.release = tasks.release;
  $scope.assign = function(stage) {
    tasks.assign(stage).success(function () {
      tasks.updateCurrent();
    });
  };
  
  $scope.manualModal = function () {
    $modal.open({templateUrl: 'manuals/markup.html', size: 'small'});
  };

  $scope.task = tasks.current;
  $scope.graphs = stages.graphs;

  $scope.debug = (window.location.hash.indexOf('debug') !== -1);
  $scope.options = {thickness: 16.5, mode: 'gauge', total: 100};
  $scope.optionsSmall = {thickness: 12, mode: 'gauge', total: 100};
  $scope.data  = [{label: "Завершено", value: 75, suffix: '%', colorComplement: '#FFFFFF', color: '#FFC107'}];
  $scope.dataDone  = [{label: "Завершено", value: 100, suffix: '%', color: '#4CAF50'}];
  $scope.dataNone  = [{label: "Завершено", value: 0, suffix: '%', color: '#212121', colorComplement: '#212121'}];
}]);