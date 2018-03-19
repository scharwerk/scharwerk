angular.module('scharwerk', 
  [
    'ui.router',
    'templates',
    'Devise',
    'mm.foundation',
    'ezfb',
    'monospaced.elastic',
    'n3-pie-chart',
    'ui.ace'
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
      name: 'proof',
      templateUrl: 'proof/_proof.html',
      controller: 'ProofCtrl',
      resolve: {
        task: ['tasks', function(tasks){
          return tasks.updateCurrent();
        }]
      }
    })

    .state('markup', {
      url: '/markup',
      name: 'markup',
      templateUrl: 'markup/_markup.html',
      controller: 'MarkupCtrl',
      resolve: {
        task: ['tasks', function(tasks){
          return tasks.updateCurrent();
        }]
      }
    })

    .state('index', {
      url: '/index',
      name: 'index',
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
'authentication',
function (authentication) {
  authentication.currentUser();
}]);