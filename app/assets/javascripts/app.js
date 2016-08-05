angular.module('flapperNews', 
  [
    'ui.router',
    'templates',
    'mm.foundation'
  ]
)
.config([
'$stateProvider',
'$urlRouterProvider',
function($stateProvider, $urlRouterProvider) {

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
}])
