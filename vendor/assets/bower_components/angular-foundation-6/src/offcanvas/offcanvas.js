angular.module('mm.foundation.offcanvas', [])
.directive('offCanvasWrapper', function($window) {
    'ngInject';
    return {
        scope: {},
        bindToController: {disableAutoClose: '='},
        controllerAs: 'vm',
        restrict: 'C',
        controller: function($scope, $element) {
            'ngInject';
            var $ctrl = this;

            var left = angular.element($element[0].querySelector('.position-left'));
            var right = angular.element($element[0].querySelector('.position-right'));
            var inner = angular.element($element[0].querySelector('.off-canvas-wrapper-inner'));
            // var overlay = angular.element(); js-off-canvas-exit
            var exitOverlay = angular.element('<div class="js-off-canvas-exit"></div>');
            inner.append(exitOverlay);

            exitOverlay.on('click', function() {
                $ctrl.hide();
            });

            $ctrl.leftToggle = function() {
                inner && inner.toggleClass('is-off-canvas-open');
                inner && inner.toggleClass('is-open-left');
                left && left.toggleClass('is-open');
                exitOverlay.addClass('is-visible');
                // is-visible
            };

            $ctrl.rightToggle = function() {
                inner && inner.toggleClass('is-off-canvas-open');
                inner && inner.toggleClass('is-open-right');
                right && right.toggleClass('is-open');
                exitOverlay.addClass('is-visible');
            };

            $ctrl.hide = function() {
                inner && inner.removeClass('is-open-left');
                inner && inner.removeClass('is-open-right');
                left && left.removeClass('is-open');
                right && right.removeClass('is-open');
                inner && inner.removeClass('is-off-canvas-open');
                exitOverlay.removeClass('is-visible');
            };

            var win = angular.element($window);

            win.bind('resize.body', $ctrl.hide);

            $scope.$on('$destroy', function() {
                win.unbind('resize.body', $ctrl.hide);
            });
        }
    };
})
.directive('leftOffCanvasToggle', function() {
    'ngInject';
    return {
        require: '^^offCanvasWrapper',
        restrict: 'C',
        link: function($scope, element, attrs, offCanvasWrapper) {
            element.on('click', function() {
                offCanvasWrapper.leftToggle();
            });
        }
    };
})
.directive('rightOffCanvasToggle', function() {
    'ngInject';
    return {
        require: '^^offCanvasWrapper',
        restrict: 'C',
        link: function($scope, element, attrs, offCanvasWrapper) {
            element.on('click', function() {
                offCanvasWrapper.rightToggle();
            });
        }
    };
})
.directive('offCanvas', function() {
    'ngInject';
    return {
        require: {'offCanvasWrapper': '^^offCanvasWrapper'},
        restrict: 'C',
        bindToController: {},
        scope: {},
        controllerAs: 'vm',
        controller: function() {}
    };
})
.directive('li', function() {
    'ngInject';
    return {
        require: '?^^offCanvas',
        restrict: 'E',
        link: function($scope, element, attrs, offCanvas) {
            if(!offCanvas || offCanvas.offCanvasWrapper.disableAutoClose){
                return;
            }
            element.on('click', function() {
                offCanvas.offCanvasWrapper.hide();
            });
        }
    };
});
