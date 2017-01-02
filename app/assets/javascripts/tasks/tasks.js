angular.module('scharwerk')
.factory('tasks', ['$http', function($http){
  var s = {
    current: {}
  };

  s.getCurrent = function() {
    return $http.get('/task.json').then(function(data){
      angular.copy(data.data, s.current);
      console.log(s);
    }, function(error){
      console.log(error);
      return false;
    });
  };

  return s;
}])



