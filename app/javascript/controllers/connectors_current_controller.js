import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="connectors-current"
export default class extends Controller {
  static values = {startId: Number, startType: String, finishId: Number, finishType: String}
  static outlets = [ "connectors" ]


  connect() {
    this.connectorsOutlet.newNodes(this.startIdValue, this.startTypeValue, this.finishIdValue, this.finishTypeValue)
  }
}
