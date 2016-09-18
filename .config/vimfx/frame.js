vimfx.listen('getCurrentHref', (data, callback) => {
  let {document} = content
  let {href} = document.activeElement
  if (!href) {
    let a = document.querySelector('a:hover')
    if (a)
      href = a.href
  }
  callback(href)
})
