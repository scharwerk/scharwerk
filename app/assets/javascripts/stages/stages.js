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
          value: Math.round(100 - 100 * stage.free / stage.total),
          color: '#FFC107',
          colorComplement: '#FFFFFF'
        }];
      });
    });
  };

  s.getUsers = function(callback) {
    return $http.get('/stats/users.json').success(callback);
  }
  
  return s;
}])



