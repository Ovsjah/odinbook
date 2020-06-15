import { Controller } from 'stimulus'

export default class extends Controller {
  resizeCarousel() {
    let items = $(this.element.querySelectorAll('.carousel-item')),
      maxHeight = Math.max(...items.map(function() {
        return $(this).outerHeight()
      }))
    items.css('min-height', maxHeight + 'px')
  }

  preview(event) {
    document.getElementById('imagePreview').src = event.target.src
    $('#imagePreviewModal').modal('show')
  }

  delete(event) {
    let currentImg = document.getElementById(`img-${event.target.dataset.imgid}`),
      currentIndicator = document.getElementById(`indicator-${event.target.dataset.imgidx}`)
    if (currentImg.nextElementSibling && currentIndicator.nextElementSibling) {
      currentImg.nextElementSibling.classList.add('active')
      currentIndicator.nextElementSibling.classList.add('active')
    } else if (currentImg.previousElementSibling && currentIndicator.previousElementSibling) {
      currentImg.previousElementSibling.classList.add('active')
      currentIndicator.previousElementSibling.classList.add('active')
    } else {
      document.getElementById(`postImagesCarousel${event.target.dataset.postid}`).remove()
    }
    currentImg.remove()
    currentIndicator.remove()
    fetch(`/posts/${event.target.dataset.postid}/images/${event.target.dataset.imgid}`, {
      method: 'DELETE',
      headers: {
        "X-CSRF-Token": this.getMetaValue("csrf-token"),
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      }
    }).then(response => response.json())
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element.getAttribute("content")
  }
}
