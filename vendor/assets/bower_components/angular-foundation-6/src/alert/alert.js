angular.module("mm.foundation.alert", [])

.controller('AlertController', function($scope, $attrs) {
    'ngInject';
    $scope.closeable = 'close' in $attrs && typeof $attrs.close !== "undefined";
})

.directive('alert', function() {
    'ngInject';
    return {
        restrict: 'EA',
        controller: 'AlertController',
        templateUrl: 'template/alert/alert.html',
        transclude: true,
        replace: true,
        scope: {
            type: '=',
            close: '&'
        }
    };
});
