angular.module('scharwerk', 
  [
    'ui.router',
    'templates',
    'Devise',
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
      controller: 'MainCtrl',
      resolve: {
        postPromise: ['posts', function(posts){
          return posts.getAll();
        }]
      }
    })

    .state('proof', {
      url: '/proof',
      templateUrl: 'proof/_proof.html',
      controller: 'ProofCtrl'
    })

    .state('index', {
      url: '/index',
      templateUrl: 'index/_index.html',
      controller: 'IndexCtrl'
    })

    .state('index_login', {
      url: '/index_login',
      templateUrl: 'index/_index_login.html',
      controller: angular.noop
    })

    .state('posts', {
      url: '/posts/{id}',
      templateUrl: 'posts/_posts.html',
      controller: 'PostsCtrl',
      resolve: {
        post: ['$stateParams', 'posts', function($stateParams, posts) {
          return posts.get($stateParams.id);
        }]
      }
    })

    .state('login', {
      url: '/login',
      templateUrl: 'auth/_login.html',
      controller: 'AuthCtrl',
      onEnter: ['$state', 'Auth', function($state, Auth) {
        Auth.currentUser().then(function (){
          $state.go('home');
        })
      }]
    })
    .state('register', {
      url: '/register',
      templateUrl: 'auth/_register.html',
      controller: 'AuthCtrl',
      onEnter: ['$state', 'Auth', function($state, Auth) {
        Auth.currentUser().then(function (){
          $state.go('home');
        })
      }] 
    });

  $urlRouterProvider.otherwise('home');

  ezfbProvider.setLocale('uk_UA');
  ezfbProvider.setInitParams({
    appId: '599480133566803',
    version: 'v2.6'
  });  
}])
