angular.module('scharwerk')
.controller('ProofCtrl', [
'$scope',
'$state',
'tasks',
'task',
'$anchorScroll',
'$modal',
function($scope, $state, tasks, task, $anchorScroll, $modal){
  if (!tasks.current.exists) {
    $state.go('index');
    return ;
  }
  
  var submitModal = function() {
    $modal.open({templateUrl: 'submitModal.html'}).result.then(function () {
      tasks.finish().success(function () {
        $state.go('index');
      });
    }, function () {
      $scope.goto(tasks.current.pages[0].id);
    });
  }

  var updatePage = function(page) {
    if (!page) {
      return submitModal();
    }
    $scope.id = page.id;
    $scope.text = page.text;
    $scope.image = page.image;

    $anchorScroll('text-top');
    $anchorScroll('image-top');
  };

  $scope.task = tasks.current;
  updatePage(tasks.current.current_page);

  $scope.save = function() {
    tasks.savePage($scope.id, $scope.text);
  }

  $scope.goto = function(id) {
    tasks.getPage(id).success(function (data) { updatePage(data) });
  }

  $scope.saveAndContinue = function() {
    tasks.savePage($scope.id, $scope.text, true).success(function() {
      updatePage(tasks.current.current_page);
    });
  }
}]);