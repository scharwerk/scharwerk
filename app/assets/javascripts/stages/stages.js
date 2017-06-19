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
    return $http.get('/stats/users.json').success(function(data){
      data.top_text = data.top.map(function(u) { 
        return '<strong>' + u.name + '&nbsp;<span class="label primary">' + u.tasks + '</sup></strong>'
      }).join('');
      data.going_text = data.going.map(function(u) { return u.name }).join(', ');
      callback(data);
    });
  }
  return s;
}])



