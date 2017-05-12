/* When recalculating starts, show the spinner container & hide the output */
$(document).on('shiny:recalculating', function(event) {
    $(".recalculating").siblings(".load-container, .shiny-spinner-placeholder").show();
    $(".recalculating").siblings(".load-container").siblings('.shiny-bound-output, .shiny-output-error').css('visibility', 'hidden');
    // if there is a proxy div, hide the previous output
    $(".recalculating").siblings(".shiny-spinner-placeholder").siblings('.shiny-bound-output, .shiny-output-error').addClass('shiny-spinner-hidden');
});

/* When new value or error comes in, hide spinner container (if any) & show the output */
$(document).on('shiny:value shiny:error', function(event) {
  console.log(event.target.id);
    $("#"+event.target.id).siblings(".load-container, .shiny-spinner-placeholder").hide();
    $("#"+event.target.id).siblings(".load-container").siblings('.shiny-bound-output').css('visibility', 'visible');
    // if there is a proxy div, show the previous output in case it was hidden
    $("#"+event.target.id).siblings(".shiny-spinner-placeholder").siblings('.shiny-bound-output').removeClass('shiny-spinner-hidden');
});
