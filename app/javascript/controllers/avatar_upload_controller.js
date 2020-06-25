import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['imgWrapper']

  showBefore(event) {
    this.imgWrapperTarget.firstElementChild.src = URL.createObjectURL(event.target.files[0])
  }
}
