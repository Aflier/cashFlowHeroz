import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Config definition shared by initialization and the mutation observer
  configs = {
    'link-back': { html: '<i class="fas fa-arrow-left me-2" data-icon></i>', position: 'afterbegin' },
    'link-to':   { html: '<i class="fas fa-chevron-right me-2" data-icon></i>', position: 'afterbegin' },
    'link-out':  { html: '<i class="fas fa-external-link-alt ms-2" data-icon></i>', position: 'beforeend' }
  }
  
  selector = 'a.link-back, a.link-to, a.link-out'

  connect() {
    // 1. Process all links already present on the page
    this.processLinks(this.element)

    // 2. Set up an observer to watch for any future DOM changes inside this element
    this.observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          // Only inspect actual HTML element nodes
          if (node.nodeType === Node.ELEMENT_NODE) {
            this.processLinks(node)
          }
        })
      })
    })

    // 3. Start observing child elements and nested trees
    this.observer.observe(this.element, { childList: true, subtree: true })
  }

  disconnect() {
    // Always clean up the observer when the controller is destroyed
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  processLinks(parentElement) {
    // Check if the parent container itself matches the selector, or find matching children
    const links = parentElement.matches?.(this.selector) 
      ? [parentElement] 
      : parentElement.querySelectorAll(this.selector)

    links.forEach((link) => {
      // Prevent duplicate icons
      if (link.querySelector('[data-icon]')) return

      // Find matching configuration class
      const matchedClass = Object.keys(this.configs).find(className => link.classList.contains(className))

      if (matchedClass) {
        const { html, position } = this.configs[matchedClass]
        link.insertAdjacentHTML(position, html)
      }
    })
  }
}

