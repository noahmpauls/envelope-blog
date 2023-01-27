function xoshiro128ss(a, b, c, d) {
  return function() {
    var t = b << 9, r = a * 5; r = (r << 7 | r >>> 25) * 9;
    c ^= a; d ^= b;
    b ^= c; a ^= d; c ^= t;
    d = d << 11 | d >>> 21;
    return (r >>> 0) / 4294967296;
  }
}

let now = new Date();
let seed = [now.getMilliseconds(), now.getSeconds(), now.getYear(), now.getMonth()];
// let seed = [1, 9, 1, 1];

let random = xoshiro128ss(seed[0], seed[1], seed[2], seed[3]);
for (let i = 0; i < 10; i++) { random() }

function randomIntFromInterval(min, max) { // min and max included 
  return Math.floor(random() * (max - min + 1) + min);
}

const envelopes = document.getElementsByClassName('envelope');


window.onload = function () {
  
  for (let e of envelopes) {
    applyRandomRotation(e);
    makeElementClickable(e);
    cascadeElementIn(e);
  }
}

function applyRandomRotation(envelopeElement) {
  envelopeElement.style.setProperty('--envelope-random-rotate', randomIntFromInterval(-7, 7) + 'deg');
}

function makeElementClickable(envelopeElement) {
  const links = envelopeElement.querySelectorAll('a');
  const mainLink = links[0];

  envelopeElement.addEventListener('click', event => {
    const isTextSelected = window.getSelection().toString();
    if (!isTextSelected) {
      mainLink.click();
    }
  });

  for (const link of links) {
    link.addEventListener('click', event => event.stopPropagation());
  }
}

function cascadeElementIn(envelopeElement) {
  envelopeElement.classList.add("cascade-in")
}