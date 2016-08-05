function DropdownToggleController($scope, $attrs, mediaQueries, $element, $position, $timeout) {
    'ngInject';
    var $ctrl = this;
    var hoverTimeout;
    const $body = angular.element(document.querySelector('body'));

    function close(e) {
        $ctrl.active = false;
        $ctrl.css = {};

        if ($ctrl.closeOnClick) {
            $body.off('click', close);
        }

        $scope.$apply();
    }

    $ctrl.$onInit = function init() {
        if ($ctrl.closeOnClick) {
            $element.on('click', (e) => e.stopPropagation());
        }
    };

    $ctrl.$onDestroy = function destroy() {
        if ($ctrl.closeOnClick) {
            $body.off('click', close);
        }
    };

    $ctrl.css = {};

    $ctrl.toggle = function() {
        $ctrl.active = !$ctrl.active;
        $ctrl.css = {};

        if (!$ctrl.active) {
            return;
        }

        positionPane(2);

        if ($ctrl.closeOnClick) {
            $body.on('click', close);
        }
    };

    $ctrl.mouseover = function() {
        $timeout.cancel(hoverTimeout);
        $ctrl.active = true;
        positionPane(1);
    }

    $ctrl.mouseleave = function() {
        $timeout.cancel(hoverTimeout);
        hoverTimeout = $timeout(function() {
            $scope.$apply(function() {
                $ctrl.active = false;
            });
        }, 250);
    };

    function positionPane(offset) {
        var dropdownTrigger = angular.element($element[0].querySelector('toggle *:first-child'));

        // var dropdownWidth = dropdown.prop('offsetWidth');
        var triggerPosition = $position.position(dropdownTrigger);

        $ctrl.css.top = triggerPosition.top + triggerPosition.height + offset + 'px';

        if ($ctrl.paneAlign === 'center') {
            $ctrl.css.left = `${triggerPosition.left + (triggerPosition.width / 2)}px`;
            $ctrl.css.transform = 'translateX(-50%)';
        } else if ($ctrl.paneAlign === 'right') {
            $ctrl.css.left = `${triggerPosition.left + triggerPosition.width}px`;
            $ctrl.css.transform = 'translateX(-100%)';
        } else {
            $ctrl.css.left = `${triggerPosition.left}px`;
        }
    }
}

function dropdownToggle($document, $window, $location) {
    'ngInject';
    return {
        scope: {},
        restrict: 'EA',
        bindToController: {
            closeOnClick: '=',
            paneAlign: '@',
            toggleOnHover: '='
        },
        transclude: {
            'toggle': 'toggle',
            'pane': 'pane'
        },
        templateUrl: 'template/dropdownToggle/dropdownToggle.html',
        controller: DropdownToggleController,
        controllerAs: '$ctrl'
    };
}


/*
 * dropdownToggle - Provides dropdown menu functionality
 * @restrict class or attribute
 * @example:

   <a dropdown-toggle="#dropdown-menu">My Dropdown Menu</a>
   <ul id="dropdown-menu" class="f-dropdown">
     <li ng-repeat="choice in dropChoices">
       <a ng-href="{{choice.href}}">{{choice.text}}</a>
     </li>
   </ul>
 */
angular.module('mm.foundation.dropdownToggle', ['mm.foundation.position', 'mm.foundation.mediaQueries'])
.directive('dropdownToggle', dropdownToggle);
