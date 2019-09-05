$(document).on 'turbolinks:load', ->
  questionId = $('.question_box').data 'question-id'
  console.log questionId

  if questionId
    App.cable.subscriptions.create { channel: 'CommentsChannel', id: questionId },
      connected: ->
        console.log this.identifier
        @perform 'follow',
      received: (data) ->
        console.log data
        if gon.user != data.author
          id = "#comments-#{data.type}-#{data.id}"
          $("#{id} ul").prepend data.view
