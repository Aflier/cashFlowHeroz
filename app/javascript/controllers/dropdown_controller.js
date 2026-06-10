import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  // Define targets to easily select elements within the controller
  static targets = ["menu", "toggle"]

  connect() {
    // Optional: Sync initial state or handle accessibility defaults
    this.closeOutside = this.closeOutside.bind(this)
    document.addEventListener("click", this.closeOutside)
  }

  disconnect() {
    // Clean up event listeners when the controller is removed from DOM
    document.removeEventListener("click", this.closeOutside)
  }

  // Toggle dropdown state
  toggleMenu(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")

  }

  // Handle clicking anywhere outside the dropdown structure
  closeOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}