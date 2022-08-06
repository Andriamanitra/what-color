const cform = document.querySelector('form');
function next() {
  let r = parseInt(256 * Math.random());
  let g = parseInt(256 * Math.random());
  let b = parseInt(256 * Math.random());
  document.querySelector('#red').value = r;
  document.querySelector('#green').value = g;
  document.querySelector('#blue').value = b;
  document.querySelector('#name').value = '';
  document.documentElement.style.setProperty('--color', `rgb(${r},${g},${b})`)
}
cform.onsubmit = function (ev) {
  fetch('', { method: 'POST', body: new FormData(cform) });
  next();
  ev.preventDefault();
}
next()
