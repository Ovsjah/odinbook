import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['toolbar', 'form', 'editBtn', 'content']

  manageForm() {
    if (this.formTarget.classList.contains('d-none')) {
      this.editBtnTarget.classList.add('text-warning')
      this.contentTarget.classList.add('d-none')
      this.formTarget.classList.remove('d-none')
    } else {
      this.editBtnTarget.classList.remove('text-warning')
      this.contentTarget.classList.remove('d-none')
      this.formTarget.classList.add('d-none')
    }
  }

  formSubmit(event) {
    event.preventDefault()
    $.post(`/comments/${this.element.id}`, $(event.target).serialize()).done(data => {
      console.log(data.content)
      this.contentTarget.textContent = data.content
      this.manageForm()
    })
  }

  destroy() {
    this.element.classList.add('d-none')
    fetch(`/comments/${this.element.id}`, {
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
