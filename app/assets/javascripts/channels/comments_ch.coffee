$(document).on 'turbolinks:load', ->
  questionId = $('.question_box').data 'question-id'

  if questionId
    App.cable.subscriptions.create { channel: 'CommentsChannel', id: questionId },
      connected: ->
        @perform 'follow',
      received: (data) ->
        if gon.user != data.author
          id = "#comments-#{data.type}-#{data.id}"
          $("#{id} ul").prepend data.view
