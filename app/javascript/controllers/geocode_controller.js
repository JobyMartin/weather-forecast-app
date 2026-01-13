import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="geocode"
export default class extends Controller {
  static targets = ["latInput", "lonInput", "alert"]
  
  connect() {
    this.hideInputs()

    if (this.hasAlertTarget) {
      this.showInputs()
    }
  }

  hideInputs() {
    this.latInputTarget.hidden = true
    this.lonInputTarget.hidden = true
  }

  showInputs() {
    this.latInputTarget.hidden = false
    this.lonInputTarget.hidden = false
  }
}
