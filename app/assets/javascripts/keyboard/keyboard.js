function KeyboardCtrl(keyboardConfig) {
  var ctrl = this;

  this.config = keyboardConfig;

  this.insertText = function(text) {
  	var element = document.getElementById(ctrl.targetId);
	
    var scrollPos = element.scrollTop;
    var strPos = element.selectionStart;

    ctrl.value = ctrl.value.slice(0, strPos) + text + ctrl.value.slice(strPos);
    strPos = strPos + text.length;
    
    element.selectionStart = strPos;
    element.selectionEnd = strPos;
    element.focus();

    element.scrollTop = scrollPos;
  }
}

angular.module('scharwerk')
.constant('keyboardConfig', {
  'Α…Ω': ['Α', 'Β', 'Γ', 'Δ', 'Ε', 'Ζ'],
  'α…ω': ['α', 'β', 'γ', 'δ', 'ε', 'ζ']
})
.component('keyboard', {
  templateUrl: 'keyboard/_keyboard.html',
  controller: KeyboardCtrl,
  bindings: {
    targetId: '@',
    value: '='
  }
});