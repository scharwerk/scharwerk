angular.module('scharwerk')
.controller('IndexCtrl', [
'$scope',
'ezfb',
function($scope, ezfb){
	function fbLogin(res) {

	}
	$scope.login = function() {
		ezfb.getLoginStatus(function (response) {
			if (response.status !== 'connected') {
            	ezfb.login(function (response) {
            		alert("login " + JSON.stringify(response));
            	});
          	} 
          	alert("already " + JSON.stringify(response));
  		});
	};
}]);