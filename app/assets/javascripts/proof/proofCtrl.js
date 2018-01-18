angular.module('scharwerk')
.controller('ProofCtrl', [
'$scope',
'$state',
'tasks',
'task',
'$anchorScroll',
'$modal',
'$timeout',
function($scope, $state, tasks, task, $anchorScroll, $modal, $timeout){
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

  $scope.releaseModal = function () {
    $modal.open({templateUrl: 'releaseModal.html'}).result.then(function () {
      tasks.release().success(function () {
        $state.go('index');
      });
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

  $scope.manualModal = function () {
    $modal.open({templateUrl: 'manualModal.html', size: 'small'});
  };

  $scope.task = tasks.current;
  updatePage(tasks.current.current_page);

  $scope.save = function() {
    tasks.savePage($scope.id, $scope.text).success(function () {
      $scope.savedStatus = 'Збережено. ';
      $timeout(function () { $scope.savedStatus = '';}, 1000);
    });
  }

  $scope.goto = function(id) {
    tasks.getPage(id).success(function (data) { updatePage(data) });
  }

  $scope.saveAndContinue = function() {
    tasks.savePage($scope.id, $scope.text, true).success(function() {
      updatePage(tasks.current.current_page);
    });
  }

  $scope.manualModal();
}]);
