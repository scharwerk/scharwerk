angular.module('scharwerk')
.factory('stages', ['$http', function($http){
  var s = {
    'test': {},
  };

  s.getStats = function() {
    return $http.get('/stats/tasks.json').success(function(data){
      console.log(s);
      angular.forEach(data, function(stage, key) {
        s[key] =
        {
          label: 'Завершено',
          suffix: '%',
          value: stage.free / stage.total,
          color: '#FFC107',
          colorComplement: '#FFFFFF'
        };
      });
      console.log(s);
    });
  };

  return s;
}])



