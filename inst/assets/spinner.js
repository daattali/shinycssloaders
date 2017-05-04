/* When recalculating starts, show the spinner container & hide the output */
$(document).on('shiny:recalculating', function(event) {
    $(".recalculating").siblings(".load-container").show();
    $(".recalculating").siblings(".load-container").siblings().css('visibility', 'hidden');
});

/* When new value or error comes in, hide spinner container (if any) & show the output */
$(document).on('shiny:value', function(event) {
    $("#"+event.target.id).siblings(".load-container").hide();
    $("#"+event.target.id).siblings(".load-container").siblings().css('visibility', 'visible');
});

$(document).on('shiny:error', function(event) {
    $("#"+event.target.id).siblings(".load-container").hide();
    $("#"+event.target.id).siblings(".load-container").siblings().css('visibility', 'visible');
});
