var filter = document.getElementById('filter');

runFilter = function(e) {
  if (filter.value.length >= 3) {
    document.querySelectorAll('tbody tr').forEach(function(e){
      var match = true;
      filter.value.split(' ').forEach(function(tag){
        if (tag.length >= 3 && !e.classList.contains(tag)) {
          match = false;
        }
      });

      if (match) {
        e.classList.remove('hide');
      } else {
        e.classList.add('hide');
      }
    });
    document.querySelectorAll('tbody tr')
  } else {
    document.querySelectorAll('tbody tr').forEach(function(e){e.classList.remove('hide')});
  }
};

runFilterButton = function(e) {
  if (filter.value.split(' ').includes(e.target.value)) {
    var newValue = "";
    filter.value.split(' ').forEach(function(s){
      if (s.length >= 3 && s != e.target.value) {
        newValue += s + ' ';
      }
    });
    filter.value = newValue;
  } else {
    filter.value += ' '+e.target.value;
  }
  runFilter(filter);
};

document.querySelectorAll('p.filter-buttons input').forEach(function(e){
  e.onsubmit = runFilterButton;
  e.onclick = runFilterButton;
});

filter.oninput = runFilter;
