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
    ga('send', 'event', 'Tasks', 'assign');
    fbq('track', 'assign');
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

  s.release = function(getNext) {
    var url = '/task.json' + (getNext ? '?next=True' : '');
    return $http.delete(url).success(function(data){
        if (getNext) {
          s.setCurrent(data);
        } else {
          s.clearCurrent();
        }
      });
  };

  s.finish = function(getNext) {
    ga('send', 'event', 'Tasks', 'finish');
    fbq('track', 'finish');
    return $http.put(
      '/task.json', 
      {done: true, next: getNext, stage: s.current.stage}
      ).success(function(data){
        if (getNext) {
          s.setCurrent(data);
        } else {
          s.clearCurrent();
        }
      });
  };

  return s;
}])
