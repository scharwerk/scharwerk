angular.module('mm.foundation.abide', [])
    .directive('abideWrap', abideWrap)
    .directive('label', labelDirective)
    .directive('input', inputDirective)
    .directive('textarea', inputDirective)
    .directive('select', inputDirective)
    .directive('abideMsg', abideMsg);

function intersect(a, b) {
    var ai = 0;
    var bi = 0;
    var result = [];

    while (ai < a.length && bi < b.length) {
        if (a[ai] < b[bi]) {
            ai++;
        } else if (a[ai] > b[bi]) {
            bi++;
        } else /* they're equal */ {
            result.push(a[ai]);
            ai++;
            bi++;
        }
    }

    return result;
}

function abideWrap() {

    function link($scope, element, attrs, form) {
        $scope.form = form;
        $scope.errors = [];
        $scope.touched = false;
        $scope.errorClass = 'error';
        $scope.classes = {};

        var submitted = false;

        $scope.$on('submitted', () => {
            submitted = true;
        });

        // function inputState(){
        //     var touched = false;
        //     var invalid = false;
        //     for(var i = 0; i < $scope.inputNames; i++){
        //         var input = form[$scope.inputNames[i]];
        //         if(input.$invalid){
        //             invalid = true;
        //             if(input.$touched){
        //                 touched = true;
        //             }
        //         }
        //     }
        //     return {touched: touched, invalid: invalid};
        // }

        $scope.$watch(() => form.$error, () => {
            $scope.errors = [];
            $scope.touched = false;

            for (var i = 0; i < $scope.inputNames.length; i++) {
                var name = $scope.inputNames[i];
                if (!form[name]) {
                    continue;
                }
                $scope.errors = $scope.errors.concat(Object.keys(form[name].$error || {}));
                $scope.touched |= form[name].$touched;
            }

            for(var i = 0; i < $scope.errors; i++){
                var errName = $scope.errors[i];
                var errMsg = msgs[errName];
                if(errMsg && errMsg.showAlways) {

                }
            }
        }, true);

        $scope.show = () => {
            var show = false;
            for (var i = 0; i < $scope.inputNames.length; i++) {
                var name = $scope.inputNames[i];
                var showAlways = intersect($scope.showAlways, $scope.errors).length > 0;

                if (!form[name]) {
                    continue;
                }

                if (form[name].$invalid && (form[name].$touched || submitted || showAlways)) {
                    show = true;
                    break;
                }
            }

            if (show) {
                $scope.classes[$scope.errorClass] = show;
            }
            return show;
        };
    }

    function controller($scope) {
        'ngInject';
        $scope.inputNames = [];
        $scope.inputs = [];
        $scope.labels = [];

        $scope.msgs = {};
        $scope.showAlways = [];

        this.addInput = function addName(element, name) {
            $scope.inputs.push(element);
            $scope.inputNames.push(name);
        };

        this.addLabel = function addName(element) {
            $scope.labels.push(element);
        };

        this.addMessage = function addMessage(key, val, showAlways, cls) {
            $scope.msgs[key] = {
                'msg': val,
                'showAlways': showAlways,
                'class': cls
            };

            if (showAlways) {
                $scope.showAlways.push(key);
            }
        };
    }

    return {
        scope: {},
        restrict: 'EA',
        require: '?^form',
        transclude: true,
        templateUrl: 'template/abide/abide.html',
        link: link,
        controller: controller
    };
}

function labelDirective() {
    'ngInject';
    return {
        restrict: 'E',
        require: '?^abideWrap',
        link: (scope, element, attrs, abideWrap) => {
            if (!abideWrap) {
                return;
            }

            abideWrap.addLabel(element);
        }
    };
}

function inputDirective() {
    'ngInject';
    return {
        restrict: 'E',
        require: '?^abideWrap',
        link: (scope, element, attrs, abideWrap) => {
            if (!abideWrap) {
                return;
            }

            abideWrap.addInput(element, attrs.name);
        }
    };
}

function abideMsg() {
    return {
        restrict: 'A',
        require: '^abideWrap',
        link: (scope, element, attrs, abideWrap) => {
            var key = attrs.abideMsg;
            var msgClass = attrs.msgClass || 'error';
            var showAlways = attrs.$attr.showAlways;
            var val = element.text().trim();
            element.css({
                'display': 'none'
            });
            abideWrap.addMessage(key, val, showAlways, msgClass);
        }
    };
}
