$(document).on('turbolinks:load', function(){
    $('.votable ').on('ajax:success', function(e){
        let json = e.detail[0];
        $(this).find('.rating h4').html('Rating: ' + json.rating);
    })
});
