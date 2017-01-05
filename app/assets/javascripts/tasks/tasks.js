angular.module('scharwerk')
.factory('tasks', ['$http', function($http){
  var s = {
    current: false
  };

  s.getCurrent  = function() {
    return s.current;
  };

  s.updateCurrent = function() {
    return $http.get('/task.json').then(function(data){
      s.current = {};
      angular.copy(data.data, s.current);
      console.log(s.current);
      return s.current;
    }, function(error){
      
      return false;
    });
  };

  s.release = function() {
    return $http.delete('/task.json').success(function() {
      s.current = false;
    });
  }
  return s;
}])



