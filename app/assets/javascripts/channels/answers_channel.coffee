$(document).on 'turbolinks:load', ->
  questionId = $('.question_box').data 'question_id'
  console.log questionId

  if questionId
    App.cable.subscriptions.create { channel: 'AnswersChannel', id: questionId },
      connected: ->
        console.log this.identifier
        @perform 'follow',
      received: (data) ->
        if gon.user != data.answer.author_id
          $('ul.question_answers').prepend JST["templates/answer"]( {
            answer: data.answer,
            files: data.files,
            links: data.links
            rating: data.rating
            author: data.answer.author_id
          } )

