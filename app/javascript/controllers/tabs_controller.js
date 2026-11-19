import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    // Show the first panel by default when the controller connects
    this.showPanel(0)
  }

  switch(event) {
    // Get the index passed from the clicked button's data-panels-index-param
    const index = event.params.index
    this.showPanel(index)
  }

  showPanel(index) {
    // Toggle visibility of panels
    this.panelTargets.forEach((panel, i) => {
      if (i === index) {
        panel.classList.remove("hidden")
      } else {
        panel.classList.add("hidden")
      }
    })

    // (Optional) Toggle styling on the tabs to show which one is active.
    // Assuming Tailwind CSS classes here for the example.
    this.tabTargets.forEach((tab, i) => {
      if (i === index) {
        tab.classList.add("border-brand-primary", "text-black")
        tab.classList.remove("border-gray-200", "text-gray-700")
      } else {
        tab.classList.add("border-gray-200", "text-gray-700")
        tab.classList.remove("border-brand-primary", "text-black")
      }
    })
  }
}
