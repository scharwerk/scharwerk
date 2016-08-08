angular.module('flapperNews', 
  [
    'ui.router',
    'templates',
    'mm.foundation',
    'ezfb'
  ]
)
.config([
'$stateProvider',
'$urlRouterProvider',
'ezfbProvider',
function($stateProvider, $urlRouterProvider, ezfbProvider) {

  $stateProvider
    .state('home', {
      url: '/home',
      templateUrl: 'home/_home.html',
      controller: 'MainCtrl'
    })

    .state('proof', {
      url: '/proof',
      templateUrl: 'proof/_proof.html',
      controller: 'ProofCtrl'
    })

    .state('posts', {
      url: '/posts/{id}',
      templateUrl: 'posts/_posts.html',
      controller: 'PostsCtrl'
    });

  $urlRouterProvider.otherwise('home');

  ezfbProvider.setLocale('uk_UA');
  ezfbProvider.setInitParams({
    appId: '599480133566803',
    version: 'v2.6'
  });  
}])
