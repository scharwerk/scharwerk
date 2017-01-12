angular.module('scharwerk')
.controller('ProofCtrl', [
'$scope',
'$state',
'tasks',
'task',
'$anchorScroll',
function($scope, $state, tasks, task, $anchorScroll){
  if (!task) {
    $state.go('index');
  }
  
  $scope.task = tasks.current;
  $scope.text = tasks.current.current_page.text;

  $scope.save = function() {
    tasks.savePage($scope.text);
  }

  $scope.saveAndContinue = function() {
    tasks.savePage($scope.text, true).success(function() {
      $scope.text = tasks.current.current_page.text;
      $anchorScroll('text-top');
      $anchorScroll('image-top');
    });
  }
}]);