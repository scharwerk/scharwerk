angular.module('flapperNews')
.factory('posts', [function(){
  var o = {
    posts: []
  };
  return o;
}])