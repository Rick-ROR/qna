$(document).on('turbolinks:load', function(){
    $('.question_box').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        let questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    })
});

