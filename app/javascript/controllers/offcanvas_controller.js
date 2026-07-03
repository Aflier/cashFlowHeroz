// app/javascript/controllers/drawer_controller.js
import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["offcanvas"]
    static values = {direction: String}

    connect() {
        console.log('Offcanvas#connect')
    }

    close() {
        if (this.directionValue === 'right') {
            this.offcanvasTarget.classList.remove('animate-drawer-right-in')
            this.offcanvasTarget.classList.add('animate-drawer-right-out')
        } else {

            // Hide the container after the animation ends
            this.offcanvasTarget.classList.remove('animate-drawer-in')
            this.offcanvasTarget.classList.add('animate-drawer-out')
        }
    }
}