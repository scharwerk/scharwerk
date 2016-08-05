function KeyboardCtrl(keyboardConfig) {
  var ctrl = this;

  this.config = keyboardConfig;

  this.insertText = function(text) {
  	var element = document.getElementById(ctrl.targetId);
	
    var scrollPos = element.scrollTop;
    var strPos = element.selectionStart;
    var value = element.value;

    element.value = value.slice(0, strPos) + text + value.slice(strPos);
    strPos = strPos + text.length;
    
    element.selectionStart = strPos;
    element.selectionEnd = strPos;
    element.focus();

    element.scrollTop = scrollPos;
  }
}

angular.module('flapperNews')
.constant('keyboardConfig', {
  'Α…Ω': ['Α', 'Β', 'Γ', 'Δ', 'Ε', 'Ζ'],
  'α…ω': ['α', 'β', 'γ', 'δ', 'ε', 'ζ']
})
.component('keyboard', {
  templateUrl: 'keyboard/_keyboard.html',
  controller: KeyboardCtrl,
  bindings: {
    targetId: '@'
  }
});