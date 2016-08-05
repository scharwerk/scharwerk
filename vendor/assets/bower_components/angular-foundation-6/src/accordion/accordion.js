function AccordionController($scope, $attrs, accordionConfig) {
    'ngInject';
    var $ctrl = this;
    // This array keeps track of the accordion groups
    $ctrl.groups = [];

    // Ensure that all the groups in this accordion are closed, unless close-others explicitly says not to
    $ctrl.closeOthers = function(openGroup) {
        var closeOthers = angular.isDefined($attrs.closeOthers) ? $scope.$eval($attrs.closeOthers) : accordionConfig.closeOthers;
        if (closeOthers) {
            angular.forEach(this.groups, function(group) {
                if (group !== openGroup) {
                    group.isOpen = false;
                }
            });
        }
    };

    // This is called from the accordion-group directive to add itself to the accordion
    $ctrl.addGroup = function(groupScope) {
        var that = this;
        this.groups.push(groupScope);
    };

    // This is called from the accordion-group directive when to remove itself
    $ctrl.removeGroup = function(group) {
        var index = this.groups.indexOf(group);
        if (index !== -1) {
            this.groups.splice(index, 1);
        }
    };

}

angular.module('mm.foundation.accordion', [])

.constant('accordionConfig', {
    closeOthers: true
})

.controller('AccordionController', AccordionController)

// The accordion directive simply sets up the directive controller
// and adds an accordion CSS class to itself element.
.directive('accordion', function() {
    'ngInject';
    return {
        restrict: 'EA',
        controller: AccordionController,
        controllerAs: '$ctrl',
        transclude: true,
        replace: false,
        templateUrl: 'template/accordion/accordion.html'
    };
})

// The accordion-group directive indicates a block of html that will expand and collapse in an accordion
.directive('accordionGroup', function() {
    'ngInject';
    return {
        require: {'accordion': '^accordion'}, // We need this directive to be inside an accordion
        restrict: 'EA',
        transclude: true, // It transcludes the contents of the directive into the template
        replace: true, // The element containing the directive will be replaced with the template
        templateUrl: 'template/accordion/accordion-group.html',
        scope: {},
        controllerAs: "$ctrl",
        bindToController: {
            heading: '@'
        }, // Create an isolated scope and interpolate the heading attribute onto this scope
        controller: function accordionGroupController($scope, $attrs, $parse) {
            'ngInject';
            var $ctrl = this;
            $ctrl.isOpen = false;

            $ctrl.setHTMLHeading = function(element) {
                $ctrl.HTMLHeading = element;
            };


            $ctrl.$onInit = function () {
                $ctrl.accordion.addGroup($ctrl);

                $scope.$on('$destroy', function(event) {
                    $ctrl.accordion.removeGroup($ctrl);
                });

                var getIsOpen;
                var setIsOpen;

                if ($attrs.isOpen) {
                    getIsOpen = $parse($attrs.isOpen);
                    setIsOpen = getIsOpen.assign;

                    $scope.$parent.$watch(getIsOpen, function(value) {
                        $ctrl.isOpen = !!value;
                    });
                }

                $scope.$watch(function(){return $ctrl.isOpen;}, function(value) {
                    if (value) {
                        $ctrl.accordion.closeOthers($ctrl);
                    }
                    setIsOpen && setIsOpen($scope.$parent, value);
                });
            };
        }
    };
})

// Use accordion-heading below an accordion-group to provide a heading containing HTML
// <accordion-group>
//   <accordion-heading>Heading containing HTML - <img src="..."></accordion-heading>
// </accordion-group>
.directive('accordionHeading', function() {
    'ngInject';
    return {
        restrict: 'EA',
        transclude: true, // Grab the contents to be used as the heading
        template: '', // In effect remove this element!
        replace: true,
        require: '^accordionGroup',
        link: function link(scope, element, attr, accordionGroupCtrl, transclude) {
            // Pass the heading to the accordion-group controller
            // so that it can be transcluded into the right place in the template
            // [The second parameter to transclude causes the elements to be cloned so that they work in ng-repeat]
            accordionGroupCtrl.setHTMLHeading(transclude(scope, function() {}));
        }
    };
})

// Use in the accordion-group template to indicate where you want the heading to be transcluded
// You must provide the property on the accordion-group controller that will hold the transcluded element
// <div class="accordion-group">
//   <div class="accordion-heading" ><a ... accordion-transclude="heading">...</a></div>
//   ...
// </div>
.directive('accordionTransclude', function() {
    'ngInject';
    return {
        require: '^accordionGroup',
        link: function(scope, element, attr, accordionGroupController) {
            scope.$watch(function() {
                return accordionGroupController.HTMLHeading;
            }, function(heading) {
                if (heading) {
                    element.html('');
                    element.append(heading);
                }
            });
        }
    };
});
