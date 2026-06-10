import {Controller} from "@hotwired/stimulus"
import {Turbo} from "@hotwired/turbo-rails"
import swal from "sweetalert2";

// Connects to data-controller="turbo"

export default class extends Controller {
    static targets = ['spinner', 'label']
    static values = {confirm: String, method: String, spin: Boolean}

    initialize() {
        // NOT SURE WHY THIS WAS NEEDE BUT IS CAUSING ISSUES!

        console.log(`Turbo#connect method: ${this.methodValue}`)
        this.element.setAttribute("data-action", "click->turbo#click")
        if (this.methodValue === 'delete') {
            this.method = 'DELETE'
            let token = document.querySelector('meta[name="csrf-token"]')
            if (token) {
                this.csrfToken = token.content;
            }
        } else {
            this.csrfToken = null;
            this.method = 'GET'
        }
    }

    click(e) {
        let that = this

        e.preventDefault()

        if (this.confirmValue) {
            console.log('We have confirm')

            const swalWithBootstrap = swal.mixin({
                customClass: {
                    confirmButton: 'btn btn-success',
                    cancelButton: 'btn btn-info'
                },
                buttonsStyling: false
            })

            console.log('alert starting ' + that.confirmValue)

            swalWithBootstrap.fire({
                html: that.confirmValue,
                showCancelButton: true,
                confirmButtonText: 'Okay',
                cancelButtonText: 'Cancel'
            })
                .then((result) => {
                        if (result.isConfirmed) {
                            console.log('do it')

                            this.url = this.element.getAttribute("href")
                            fetch(this.url, {
                                method: that.method,
                                headers: {
                                    Accept: "text/vnd.turbo-stream.html",
                                    "X-CSRF-Token": that.csrfToken,
                                }
                            })
                                .then(r => r.text())
                                .then(html => Turbo.renderStreamMessage(html))
                        }
                    }
                )
        } else {
            console.log('We dont have confirm')

            if (this.spinValue) {
                this.labelTarget.hidden = true
                this.spinnerTarget.hidden = false
            }

            this.url = this.element.getAttribute("href")
            fetch(this.url, {
                method: that.method,
                headers: {
                    Accept: "text/vnd.turbo-stream.html",
                    "X-CSRF-Token": that.csrfToken,
                }
            })
                .then(r => r.text())
                .then(html => Turbo.renderStreamMessage(html))
        }
    }
}

