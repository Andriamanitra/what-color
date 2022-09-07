const HEX_COLOR_REGEX = /^#(?:[A-Fa-f0-9]{3}){1,2}$/;

const cform = document.querySelector('form');
function next() {
  let r = parseInt(256 * Math.random());
  let g = parseInt(256 * Math.random());
  let b = parseInt(256 * Math.random());
  document.querySelector('#red').value = r;
  document.querySelector('#green').value = g;
  document.querySelector('#blue').value = b;
  document.querySelector('#name').value = '';
  document.documentElement.style.setProperty('--color', `rgb(${r},${g},${b})`);
}
cform.onsubmit = function (ev) {
  ev.preventDefault();
  const formData = new FormData(cform);
  const name = formData.get("name");
  if (formData.get("name").match(HEX_COLOR_REGEX)) {
    alert("Very clever, but we are asking for color names in natural language!");
    return;
  }
  fetch('', { method: 'POST', body: formData });
  next();
}
next()
