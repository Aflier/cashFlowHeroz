import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  closeOutside(event) {
    const panel = this.element.querySelector("el-dialog-panel")

    if (panel && !panel.contains(event.target)) {
      this.close()
    }
  }

  close() {
    if (typeof this.element.close === "function") {
      this.element.close()

      const frame = this.element.closest("turbo-frame")
      if (frame) {
        frame.innerHTML = ""
      }
    }
  }
}