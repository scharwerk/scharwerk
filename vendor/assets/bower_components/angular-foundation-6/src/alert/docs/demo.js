angular.module('foundationDemoApp').controller('AlertDemoCtrl', function($scope) {
  $scope.alerts = [
    { type: 'alert', msg: 'Oh snap! Change a few things up and try submitting again.' },
    { type: 'success round', msg: 'Well done! You successfully read this important alert message.' }
  ];

  $scope.addAlert = function() {
    $scope.alerts.push({type: 'alert', msg: "Another alert!"});
  };

  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
  };

});
