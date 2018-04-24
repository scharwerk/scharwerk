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

  var editor = null;
  $scope.aceLoaded = function(_editor) {
    _editor.setFontSize(18);
    editor = _editor;
  };

  $scope.insertChar = function(char) {
    editor.insert(char);
    editor.focus();
  };

  $scope.insertTex = function(tex) {
    var s = tex.replace('#', editor.getSelectedText());
    editor.insert(s);
    editor.focus();
  };

  $scope.submitModal = function() {
    $modal.open({templateUrl: 'submitModal.html'}).result.then(function (getNext) {
      $scope.tex = editor.getValue();
      tasks.updateTex($scope.tex, true).success(function () {
        tasks.finish(getNext).success(function () {
          if (!getNext) {
            $state.go('index');
            return ;
          };

          updateTex(tasks.current);
        });
      });
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
        updateTex(tasks.current);
      });
    });    
  }

  var updateTex = function(task) {
    $scope.tex = task.tex;
    $scope.images = {};
    $scope.pages = task.pages;

    $scope.preview = false;
    $scope.loading = false;
  };

  $scope.manualModal = function () {
    $modal.open({templateUrl: 'manuals/markup.html', size: 'small'});
  };
  
  $scope.showPreview = function () {
    $scope.preview = true;
    $scope.loading = true;
    // reset value from editor
    if (editor) {
      $scope.tex = editor.getValue();
    };
    tasks.updateTex($scope.tex, true).success(function () {
      $scope.images = tasks.current.images;
      $scope.loading = false;
    });
  };

  $scope.hidePreview = function () {
    $scope.preview = false;
  };
  
  $scope.savedStatus = 'Зберегти';
  $scope.save = function() {
    tasks.updateTex($scope.tex, false).success(function () {
      $scope.savedStatus = 'Збережено.';
      $timeout(function () { $scope.savedStatus = 'Зберегти'; }, 1000);
    });
  }
  
  updateTex(tasks.current);
  $scope.manualModal();
}]);
