import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    this.prevScrollPos = window.pageYOffset
  }

  manageScroll() {
    let currentScrollPos = window.pageYOffset
    if (this.prevScrollPos > currentScrollPos) {
      this.element.style.top = '0'
    } else {
      this.element.style.top = '-138px'
    }
    this.prevScrollPos = currentScrollPos
  }
}
