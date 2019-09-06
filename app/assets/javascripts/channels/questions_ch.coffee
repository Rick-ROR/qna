$(document).on 'turbolinks:load', ->
  questions = $("ul.questions")

  if questions.length
    App.cable.subscriptions.create('QuestionsChannel', {
      connected: ->
        @perform 'follow',
      received: (data) ->
        questions.prepend data
    })
