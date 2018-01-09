(function() {
var output_states = [];

function show_spinner(id) {
    
    var root = $("#"+id).closest(".shiny-spinner-output-container");
    
    root.find(".load-container, .shiny-spinner-placeholder").removeClass('shiny-spinner-hidden');
    
    root.find(".load-container").siblings(":not(.shiny-spinner-init)").css('visibility', 'hidden');
    root.has(".shiny-spinner-placeholder").find(":not(.load-container, .loader, .shiny-spinner-placeholder, .shiny-spinner-init)").addClass('shiny-spinner-hidden');

    setTimeout(function() {
        root.find(".shiny-spinner-init").addClass('shiny-spinner-hidden');
    }, 100);
    
}

function hide_spinner(id) {
    
    var root = $("#"+id).closest(".shiny-spinner-output-container");
    
    root.find(".load-container, .shiny-spinner-placeholder").addClass('shiny-spinner-hidden');
    root.find(".load-container").siblings().css('visibility', 'visible');
    root.find(".shiny-spinner-init").remove();
    // if there is a proxy div, show the previous output in case it was hidden
    root.find(":not(.load-container, .loader, .shiny-spinner-placeholder, .shiny-spinner-init)").removeClass('shiny-spinner-hidden');
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
