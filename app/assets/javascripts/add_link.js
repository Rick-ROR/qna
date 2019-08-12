$(document).on('turbolinks:load', function(){
    $('.container').on('click', '.add-link', function(e) {
        e.preventDefault();
        let links = $(this).closest('form').find('.new_link');
        let number = links.length;
        let newLink = links.first().clone().attr("id", `link-${number}`);

        newLink.find('label').each(function(index, element) {
            let old_attr = $(this).attr( "for" );
            $(this).attr( "for",  old_attr.replace(/links_attributes_0/i, `links_attributes_${number}`));
        });

        newLink.find('textarea, input').each(function(index, element) {
            let oldID = $(this).attr( "id" );
            let oldName = $(this).attr( "name" );
            $(this).val('');
            $(this).attr({
                id: oldID.replace(/links_attributes_0/i, `links_attributes_${number}`),
                name: oldName.replace(/links_attributes]\[0/i, `links_attributes][${number}`)
            });
        });

        newLink.insertAfter(links.last());
    })
});
