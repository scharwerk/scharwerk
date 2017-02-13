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

  s.getTop = function(callback) {
    return $http.get('/stats/top.json').success(function(data){
      var top = data.top.map(function(u) { return u.name }).join(', ');
      var going = data.going.map(function(u) { return u.name }).join(', ');
      callback(top, going);
    });
  }
  return s;
}])



