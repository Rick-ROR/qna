$(document).on 'turbolinks:load', ->
  $('.question_box').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    questionId = $(this).data('questionId')
    $('form#edit-question-' + questionId).removeClass 'hidden'
    return
  return

$ ->
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      console.log 'hey guys!'
      @perform 'follow'
#      setTimeout ->
#        $("ul.questions").prepend '<li class="question">DUP DUP DUP</li>'
#      , 15000
      ,
    received: (data) ->
      console.log 'received', data
      $("ul.questions").prepend data
  })
