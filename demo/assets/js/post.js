// TODO: allow captions to be toggled from CMS
postImages = document.querySelectorAll("#post img")
for (const child of postImages) {
  if (child.title.length > 0) {
    const caption = document.createElement('p');
    caption.innerText = child.title;
    caption.classList.add("caption")
    child.parentElement.appendChild(caption);
  }
}

