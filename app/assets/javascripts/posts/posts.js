angular.module('flapperNews')
.factory('posts', ['$http', function($http){
  var o = {
    posts: []
  };
  return o;
}])

o.getAll = function() {
	return $http.get('/posts.json').success(function(data){
		angular.copy(data, o.posts);
	});
};
