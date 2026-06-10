# Pin npm packages by running ./bin/importmap
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "sortablejs" # @1.15.6
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.13
pin "sweetalert2" # @11.17.2
pin "@stimulus-components/sortable", to: "@stimulus-components--sortable.js" # @5.0.3
pin "trix"
pin "@rails/actiontext", to: "actiontext.esm.js"
pin "@rails/activestorage" # @5.2.8
