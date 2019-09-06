$(document).on 'turbolinks:load', ->
  $('.question_box').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    questionId = $(this).data('questionId')
    $('form#edit-question-' + questionId).removeClass 'hidden'
    return
  return
