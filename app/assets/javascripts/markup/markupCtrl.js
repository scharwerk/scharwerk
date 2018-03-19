angular.module('scharwerk')
.controller('MarkupCtrl', [
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
    $modal.open({templateUrl: 'submitModal.html'}).result.then(function (getNext) {
      tasks.finish(getNext).success(function () {
        if (!getNext) {
          $state.go('index');
          return ;
        };

        updatePage(tasks.current.current_page);
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


  $scope.skipModal = function () {
    $modal.open({templateUrl: 'skipModal.html'}).result.then(function () {
      tasks.release(true).success(function () {
        updatePage(tasks.current.current_page);
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

  $scope.tex = tasks.current.tex;
  // updatePage(tasks.current.current_page);

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
