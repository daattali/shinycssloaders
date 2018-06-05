(function() {
var output_states = [];

function escapeSelector(s) {
    return s.replace(/([!"#$%&'()*+,-./:;<=>?@\[\\\]^`{|}~])/g, "\\$1");
}

function show_spinner(id) {
    var selector = "#"+escapeSelector(id);
    $(selector).siblings(".load-container, .shiny-spinner-placeholder").removeClass('shiny-spinner-hidden');
    $(selector).siblings(".load-container").siblings('.shiny-bound-output, .shiny-output-error').css('visibility', 'hidden');
    // if there is a proxy div, hide the previous output
    $(selector).siblings(".shiny-spinner-placeholder").siblings('.shiny-bound-output, .shiny-output-error').addClass('shiny-spinner-hidden');
}

function hide_spinner(id) {
    var selector = "#"+escapeSelector(id);
    $(selector).siblings(".load-container, .shiny-spinner-placeholder").addClass('shiny-spinner-hidden');
    $(selector).siblings(".load-container").siblings('.shiny-bound-output').css('visibility', 'visible');
    // if there is a proxy div, show the previous output in case it was hidden
    $(selector).siblings(".shiny-spinner-placeholder").siblings('.shiny-bound-output').removeClass('shiny-spinner-hidden');
}

function update_spinner(id) {
  if (!(id in output_states)) {
    show_spinner(id);
  }
  if (output_states[id] <= 0) {
    show_spinner(id);
  } else {
    hide_spinner(id);
  }
}

$(document).on('shiny:bound', function(event){ 
  /* if not bound before, then set the value to 0 */
  if (!(event.target.id in output_states)) {
    output_states[event.target.id] = 0;
  }
  update_spinner(event.target.id);
});

/* When recalculating starts, show the spinner container & hide the output */
$(document).on('shiny:outputinvalidated', function(event) {
  output_states[event.target.id] = 0;
  update_spinner(event.target.id);
});

/* When new value or error comes in, hide spinner container (if any) & show the output */
$(document).on('shiny:value shiny:error', function(event) {
  output_states[event.target.id] = 1;
  update_spinner(event.target.id);
});
}());
