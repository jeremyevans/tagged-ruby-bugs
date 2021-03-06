var filter = document.getElementById('filter');

runFilter = function(e) {
  var numMatched = 0;
  if (filter.value.length >= 3) {
    document.querySelectorAll('tbody tr').forEach(function(e){
      var match = true;
      filter.value.split(' ').forEach(function(tag){
        if (tag[0] == '!') {
          tag = tag.substr(1);
          if (tag.length >= 3 && e.classList.contains(tag)) {
            match = false;
          }
        }
        else if (tag.length >= 3 && !e.classList.contains(tag)) {
          match = false;
        }
      });

      if (match) {
        e.classList.remove('hide');
        numMatched++;
      } else {
        e.classList.add('hide');
      }
    });
    document.querySelectorAll('tbody tr')
  } else {
    document.querySelectorAll('tbody tr').forEach(function(e){numMatched++; e.classList.remove('hide')});
  }
  window.location.hash = filter.value.replace(/ /g, '-');
  document.getElementById("matched").innerHTML = numMatched;
};

runFilterButton = function(e) {
  var filterParts = filter.value.split(' ');
  var newValue;
  var value = e.target.value;
  var negateValue = "!"+value;

  if (filterParts.includes(value)) {
    newValue = negateValue+" ";
  } else if (filterParts.includes(negateValue)) {
    newValue = "";
  }

  if (typeof(newValue) === "string") {
    filterParts.forEach(function(s){
      if (s.length >= 3 && s != value && s != negateValue) {
        newValue += s + ' ';
      }
    });
    filter.value = newValue;
  } else {
    filter.value += ' '+value;
  }
  runFilter(filter);
};

document.querySelectorAll('p.filter-buttons input').forEach(function(e){
  e.onsubmit = runFilterButton;
  e.onclick = runFilterButton;
});

filter.oninput = runFilter;
filter.value = window.location.hash.substr(1).replace(/-/g, ' ');
runFilter();
