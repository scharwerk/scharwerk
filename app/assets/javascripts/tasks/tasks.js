angular.module('scharwerk')
.factory('tasks', ['$http', function($http){
  var s = {
    current: {}
  };

  s.setCurrent = function(data) {
    angular.copy(data, s.current);
    s.current.exists = true;
    return s.current;
  }

  s.clearCurrent = function() {
    angular.copy({exists: false}, s.current);

    return s.current;
  };

  s.updateCurrent = function() {
    return $http.get('/task.json').then(function(data){
      return s.setCurrent(data.data);
    }, s.clearCurrent);
  };

  s.assign = function(stage) {
    return $http.post('/task.json', {stage: stage}).success(s.setCurrent);
  };

  s.savePage = function(id, text, done) {
    return $http.put(
        '/task/pages/' + id + '.json',
        {text: text, done: done}
      ).success(s.setCurrent);
  };

  s.getPage = function(id) {
    return $http.get('/task/pages/' + id + '.json');
  };

  s.release = function() {
    return $http.delete('/task.json').success(s.clearCurrent);
  };

  return s;
}])
