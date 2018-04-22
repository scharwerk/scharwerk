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

  var updateTex = function(task) {
    $scope.tex = tasks.current.tex;
    $scope.images = tasks.current.images;
  };

  updateTex(tasks.current);

  $scope.manualModal = function () {
    $modal.open({templateUrl: 'manuals/markup.html', size: 'small'});
  };

  
  $scope.preview = false;
  $scope.loading = false;
  
  $scope.showPreview = function () {
    $scope.preview = true;
    $scope.loading = true;
    // reset value from editor
    $scope.tex = editor.getValue();
    tasks.updateTex($scope.tex, true).success(function () {
      $scope.images = tasks.current.images;
      $scope.loading = false;
    });
  };

  $scope.hidePreview = function () {
    $scope.preview = false;
  };
  
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

  // $scope.manualModal();
}]);
