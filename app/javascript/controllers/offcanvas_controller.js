// app/javascript/controllers/drawer_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["offcanvas"]

  connect() {
   console.log('Offcanvas#connect')
  }

  close() {
    // Hide the container after the animation ends

      this.offcanvasTarget.classList.remove('animate-drawer-in')
      this.offcanvasTarget.classList.add('animate-drawer-out')


  }
}