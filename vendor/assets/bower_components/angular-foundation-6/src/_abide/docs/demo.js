angular.module('foundationDemoApp').controller('AbideDemoCtrl', function($scope, $document) {
    $scope.submit = function(){
        console.log($scope.form);
        if(!$scope.form.$valid){
            // $document.scrollToElementAnimated($document[0].querySelector('.ng-invalid'));
            $scope.$broadcast('submitted');
            $scope.valid = false;
            return;
        }
        $scope.valid = true;
    };
});
