angular.module('scharwerk')
.factory('stages', ['$http', function($http){
  var s = {
    graphs: {}
  };

  s.getStats = function() {
    return $http.get('/stats/tasks.json').success(function(data){
      angular.forEach(data, function(stage, key) {
        s.graphs[key] =
        [{
          label: 'Завершено',
          suffix: '%',
          value: Math.floor(100 * stage.commited / stage.total),
          color: '#FFC107',
          colorComplement: '#FFFFFF',
          free: (!!stage.free)
        }];
      });
    });
  };

  s.getUsers = function(callback) {
    return $http.get('/stats/users.json').success(callback);
  }
  
  return s;
}])



