import Rails from "@rails/ujs";
Rails.start();  //enables the handling of DELETE, PATCH, and POST requests from links
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export { application }
