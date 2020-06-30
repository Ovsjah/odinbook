import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['carouselControls']

  preview(event) {
    document.getElementById('imagePreview').src = event.target.src
    $('#imagePreviewModal').modal('show')
  }

  delete(event) {
    let currentImg = this.element.querySelector(`#img-${event.target.dataset.imgid}`),
      currentIndicator = this.element.querySelector(`#indicator-${event.target.dataset.imgid}`)
    if (this.element.querySelectorAll('.carousel-item').length - 1 == 1) {
      this.carouselControlsTarget.classList.add('d-none')
      this.element.querySelector('.carousel-indicators').classList.add('d-none')
    }
    if (currentImg.nextElementSibling && currentIndicator.nextElementSibling) {
      currentImg.nextElementSibling.classList.add('active')
      currentIndicator.nextElementSibling.classList.add('active')
    } else if (currentImg.previousElementSibling && currentIndicator.previousElementSibling) {
      currentImg.previousElementSibling.classList.add('active')
      currentIndicator.previousElementSibling.classList.add('active')
    } else {
      this.element.remove()
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
