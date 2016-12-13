angular.module('scharwerk')
.factory('stages', ['$http', function($http){
  var s = {
    graphs: {}
  };

  s.getStats = function() {
    return $http.get('/stats/tasks.json').success(function(data){
      console.log(s);
      angular.forEach(data, function(stage, key) {
        s.graphs[key] =
        [{
          label: 'Завершено',
          suffix: '%',
          value: 100 * stage.free / stage.total,
          color: '#FFC107',
          colorComplement: '#FFFFFF'
        }];
      });
    });
  };

  return s;
}])



