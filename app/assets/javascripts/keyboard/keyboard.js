function KeyboardCtrl(keyboardConfig) {
  var ctrl = this;

  this.config = keyboardConfig;
  this.chars = {}

  angular.forEach(keyboardConfig, function(string, key) {
    this[key] = string.split('');
  }, this.chars);

  this.insertText = function(text) {
  	var element = document.getElementById(ctrl.targetId);
	
    var scrollPos = element.scrollTop;
    var strPos = element.selectionStart;
    var endPos = element.selectionEnd;

    element.value = element.value.slice(0, strPos) + text + element.value.slice(endPos);
    strPos = strPos + text.length;

    element.selectionStart = strPos;
    element.selectionEnd = strPos;
      
    element.scrollTop = scrollPos;
    element.focus();
    angular.element(element).triggerHandler('input');
  }
};

angular.module('scharwerk')
.constant('keyboardConfig', {
  '«»…VI': "'’„“«»[]/—ҐґIVXLcvmΔ…",
  'Ää…Ùù': 'ÄäÀàÂâÆæÇçÉéÈèÊêËëÎîÏïÖöÔôŒœÜüÙùÛûŸÿß',
  'Α…Ω': 'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ',
  'α…ω': 'αβγδεζηθικλμνξοπρσςτυφχψω'
})
.component('keyboard', {
  templateUrl: 'keyboard/_keyboard.html',
  controller: ['keyboardConfig', KeyboardCtrl],
  bindings: {
    targetId: '@',
    value: '='
  }
});
