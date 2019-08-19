$(document).on('turbolinks:load', function(){
    $('.question_answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        let answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    $('form.new-answer').on('ajax:success', function(e){
        let xhr = e.detail[2];
        $('.question_answers').append(xhr.responseText);
    })
        .on('ajax:error', function(e){
            let xhr = e.detail[2];
            $('.answer-errors').html(xhr.responseText);
        })
});

