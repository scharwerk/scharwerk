angular.module('scharwerk')
.factory('stages', ['$http', function($http){
  var s = {
    graphs: {}
  };

  s.getStats = function() {
    return $http.get('/stats/tasks.json').success(function(data){
      angular.forEach(data, function(stage, key) {
        // temporary fix
        // add 500 to markup and 100 to markup complex
        stage.total = stage.total + ((key == 'markup') ? 500 : 100);
        // check if undefined and summ
        finished = (stage.commited || 0) + (stage.unchanged || 0) + (stage.reproof || 0);
        console.log(finished);
        s.graphs[key] =
        [{
          label: 'Завершено',
          suffix: '%',
          value: Math.floor(100 * finished / stage.total),
          color: '#FFC107',
          colorComplement: '#FFFFFF',
          free: (!!stage.free),
          total: stage.total,
          finished: finished
        }];
      });
    });
  };

  s.getUsers = function(callback) {
    return $http.get('/stats/users.json').success(callback);
  }
  
  return s;
}])



