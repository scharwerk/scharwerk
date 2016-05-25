angular.module('flapperNews', [])
.controller('MainCtrl', [
'$scope',
function($scope){
  $scope.posts = [
	  {title: 'post1', upvotes: 5},
	  {title: 'post2', upvotes: 2},
	  {title: 'post3', upvotes: 15},
	  {title: 'post4', upvotes: 9},
	  {title: 'post5', upvotes: 4}
  ];
  $scope.addPost = function() {
    if(!$scope.title || $scope.title === '') { return; }
    $scope.posts.push({title: $scope.title, upvotes: 0});
    $scope.title = '';
  };
  $scope.incrementUpvotes = function(post) {
    post.upvotes += 1;
  };
}]);


