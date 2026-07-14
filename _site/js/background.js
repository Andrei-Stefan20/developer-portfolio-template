(function () {
  var STATES = ['none', 'grid', 'dots'];
  var root = document.documentElement;
  var btn = document.querySelector('.bg-toggle');
  if (!btn) return;

  function current() {
    var value = root.getAttribute('data-bg');
    return STATES.indexOf(value) === -1 ? 'none' : value;
  }

  btn.addEventListener('click', function () {
    var next = STATES[(STATES.indexOf(current()) + 1) % STATES.length];
    root.setAttribute('data-bg', next);
    try { localStorage.setItem('bg-pattern', next); } catch (e) {}
  });
})();
