(function () {
  var root = document.documentElement;
  var btn = document.querySelector('.font-toggle');
  if (!btn) return;

  function sync() {
    btn.classList.toggle('is-active', root.getAttribute('data-font') === 'hand');
  }
  sync();

  btn.addEventListener('click', function () {
    var next = root.getAttribute('data-font') === 'hand' ? 'default' : 'hand';
    if (next === 'default') {
      root.removeAttribute('data-font');
    } else {
      root.setAttribute('data-font', next);
    }
    try { localStorage.setItem('font-style', next); } catch (e) {}
    sync();
  });
})();
