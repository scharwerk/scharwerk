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
  
  var updatePage = function(page) {
    $scope.id = page.id;
    $scope.text = page.text;
    $scope.image = page.path;

    $anchorScroll('text-top');
    $anchorScroll('image-top');
  };

  $scope.task = tasks.current;
  updatePage(tasks.current.current_page);

  $scope.save = function() {
    tasks.savePage($scope.text);
  }

  $scope.goto = function(id) {
    tasks.getPage(id).success(function (data) { updatePage(data) });
  }

  $scope.saveAndContinue = function() {
    tasks.savePage($scope.text, true).success(function() {
      updatePage(tasks.current.current_page);
    });
  }
}]);