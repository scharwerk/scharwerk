angular.module('flapperNews')
.controller('ProofCtrl', [
'$scope',
function($scope){
	$scope.image = '/assets/1.png';
	$scope.text = 'первый текст';

	$scope.saveAndContinue = function() {
		alert($scope.text);
		$scope.image = '/assets/2.png';
		$scope.text = 'второй текст';
	}
}]);