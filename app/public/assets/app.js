var labels = document.getElementsByTagName('label');
for (var i = 0; i < labels.length; i++) {
  var label = labels[i];

  label.ondblclick = function(event) {
    var path = event.target.getAttribute('data-edit-path');
    window.location = path;
  }
}
