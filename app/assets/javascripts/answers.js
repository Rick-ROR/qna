$(document).on('turbolinks:load', function(){
    $('.question_answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    $('form.new-answer').on('ajax:success', function(e){
        let answer = e.detail[0];
        $('.question_answers').append('<p>' + answer.body + '</p>');
    })
        .on('ajax:error', function(e){
            console.log(e.detail);
            let errors = e.detail[0];
            $.each(errors, function (index, value) {
                $('.answer-errors').append('<p>' + value + '</p>');
            });
        })
});

