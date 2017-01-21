angular.module('scharwerk', 
  [
    'ui.router',
    'templates',
    'Devise',
    'mm.foundation',
    'ezfb',
    'monospaced.elastic',
    'n3-pie-chart'
  ]
)
.config([
'$stateProvider',
'$urlRouterProvider',
'ezfbProvider',
function($stateProvider, $urlRouterProvider, ezfbProvider) {

  $stateProvider
    .state('proof', {
      url: '/proof',
      templateUrl: 'proof/_proof.html',
      controller: 'ProofCtrl',
      resolve: {
        task: ['tasks', function(tasks){
          return tasks.updateCurrent();
        }]
      }
    })

    .state('index', {
      url: '/index',
      templateUrl: 'index/_index.html',
      controller: 'IndexCtrl',
      resolve: {
        stagesPromise: ['stages', function(stages){
          return stages.getStats();
        }]
      }
    });

  $urlRouterProvider.otherwise('index');

  // This is hack to use test app on localhost
  isLocal = (window.location.hostname == 'localhost');
  ezfbProvider.setLocale('uk_UA');
  ezfbProvider.setInitParams({
    appId: isLocal ? '1844624322448931' : '599480133566803',
    version: 'v2.6'
  });  

}])
.run([
'Auth',
function (Auth) {
  Auth.currentUser();
}]);