angular.module('scharwerk')
.controller('ProofCtrl', [
'$scope',
'$state',
'tasks',
'task',
function($scope, $state, tasks, task){
	if (!task) {
		$state.go('index');
	}
	
	$scope.task = task;
	$scope.image = task.current_page.path;
	$scope.text = task.current_page.text;

	$scope.saveAndContinue = function() {
		alert($scope.text);
		$scope.image = '/assets/2.png';
		$scope.text = 'второй текст';
	}
	
}]);