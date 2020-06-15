import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['likeCounter', 'likeBtn', 'commentBtn', 'formWithComments']

  like() {
    if (this.likeBtnTarget.classList.contains('text-warning')) {
      this.likeBtnTarget.classList.remove('text-warning')
      this.fetchLikes(`/dislike/${this.data.get('post-id')}`)
    } else {
      this.likeBtnTarget.classList.add('text-warning')
      this.fetchLikes(`/like/${this.data.get('post-id')}`)
    }
  }

  comment() {
    if (this.formWithCommentsTarget.classList.contains('d-none')) {
      this.commentBtnTarget.classList.add('text-warning')
      this.formWithCommentsTarget.classList.remove('d-none')
    } else {
      this.commentBtnTarget.classList.remove('text-warning')
      this.formWithCommentsTarget.classList.add('d-none')
    }
  }

  commentSubmit(event) {
    event.stopImmediatePropagation()
    event.preventDefault()
    $.post('/comments', $(event.target).serialize()).done(data => {
      event.target.reset()
      let parent = event.target.parentElement,
        clonedComment = this.cloneCommentFrom(parent.querySelector('.list-group-item.d-none'), data)
      parent.querySelector('.list-group').prepend(clonedComment)
      this.patchFormFor(clonedComment)
    })
  }

  cloneCommentFrom(el, data) {
    let clonedComment = el.cloneNode(true)
    clonedComment.querySelector('.content').textContent = data.content
    clonedComment.classList.remove('d-none')
    clonedComment.setAttribute('id', data.id)
    clonedComment.querySelector(`#comment_content_post_id_${data.post_id}`).textContent = data.content
    return clonedComment
  }

  patchFormFor(comment) {
    let form = comment.querySelector('form'),
      input = document.createElement("input")
    input.setAttribute("type", "hidden")
    input.setAttribute("name", "_method")
    input.setAttribute("value", "patch")
    form.action = `/comments/${comment.id}`
    form.prepend(input)
  }

  fetchLikes(path) {
    fetch(path).then(response => {
      return response.json()
    }).then(data => {
      this.likeCounterTarget.textContent = data.likes_counter
    })
  }
}
