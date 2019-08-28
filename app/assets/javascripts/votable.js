$(document).on('turbolinks:load', function(){
    $('.votable ').on('ajax:success', function(e){
        let answer = e.detail[0];
        console.log($(answer));
        $(this).find('.rating h3').html('Rating: ' + answer.rating);
    })
});


