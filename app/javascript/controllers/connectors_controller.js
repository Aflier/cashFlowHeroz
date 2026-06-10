import {Controller} from "@hotwired/stimulus"
import {Turbo} from "@hotwired/turbo-rails";

export default class extends Controller {
  static targets = ['connectorStart', 'connectorFinish', 'connectorStartOff', 'connectorFinishOff']
  static values = {startId: Number, startType: String, finishId: Number, finishType: String}

  connect() {
    // TODO - Not sure this is needed!

    let token = document.querySelector('meta[name="csrf-token"]')
    if (token) {
      this.csrfToken = token.content;
    }
  }

  newNodes(startId, startType, finishId, finishType) {
    this.startIdValue = startId
    this.startTypeValue = startType
    this.finishIdValue = finishId
    this.finishTypeValue = finishType

    if (this.startIdValue !== 0) {
      this.looking_for_finish()
    }

    if (this.finishIdValue !== 0) {
      this.looking_for_start()
    }

    if (this.startIdValue === 0 && this.finishIdValue === 0) {
      this.show_labels()
    }

    // this.sendConnector()
  }

  looking_for_start() {
    this.connectorStartTargets.forEach(function (element, index) {
      element.hidden = false
    });

    this.connectorStartOffTargets.forEach(function (element, index) {
      element.hidden = true
    });


    this.connectorFinishTargets.forEach(function (element, index) {
      element.hidden = true
    });

    this.connectorFinishOffTargets.forEach(function (element, index) {
      element.hidden = false
    });
  }

  looking_for_finish() {
    this.connectorStartTargets.forEach(function (element, index) {
      element.hidden = true
    });

    this.connectorStartOffTargets.forEach(function (element, index) {
      element.hidden = false
    });


    this.connectorFinishTargets.forEach(function (element, index) {
      element.hidden = false
    });

    this.connectorFinishOffTargets.forEach(function (element, index) {
      element.hidden = true
    });
  }

  show_labels() {
    this.connectorStartTargets.forEach(function (element, index) {
      element.hidden = false
    });

    this.connectorStartOffTargets.forEach(function (element, index) {
      element.hidden = true
    });


    this.connectorFinishTargets.forEach(function (element, index) {
      element.hidden = false
    });

    this.connectorFinishOffTargets.forEach(function (element, index) {
      element.hidden = true
    });
  }
}