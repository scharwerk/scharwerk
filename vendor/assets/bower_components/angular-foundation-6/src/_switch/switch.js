function switchController(switchId){
    'ngInject';
    var $ctrl = this;
    $ctrl.name = 'switchLabel' + switchId.id++;

    $ctrl.$onInit = ()=> {
        $ctrl.ngModel.$render = (val) => {
            // $ctrl.model = val;0
        };
    };

    $ctrl.getSetModel = (val) => {
        if(angular.isDefined(val)){
            $ctrl.ngModel.$setViewValue(val);
        }
        return $ctrl.ngModel.$modelValue;
    };

}


angular.module('mm.foundation.switch', [])
.value('switchId', {id: 0})
.component('switch', function() {
    'ngInject';
    return {
        require: {
            'ngModel': 'ngModel'
        },
        controller: switchController,
        bind: {
            'type': '=',
            'name': '=',
            'classes': '=',
            'srText': '='
        },
        templateUrl: 'template/switch/switch.html',
    };
});
