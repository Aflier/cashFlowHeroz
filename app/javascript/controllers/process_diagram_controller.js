import {Controller} from "@hotwired/stimulus"
// import Rails from "@rails/ujs";
// import consumer from "../channels/consumer"
import {Turbo} from "@hotwired/turbo-rails";

class Bubble {
    constructor(myCanvas, x, y, name, ident, ident_activity, purpose, external, parent_name, controller) {
        this.controller = controller

        this.BUBBLE__WIDTH = 100
        this.BUBBLE__HEIGHT = 55
        this.BUBBLE__TEXT_WIDTH = this.BUBBLE__WIDTH - 10

        this.myCanvas = myCanvas
        this.dragging = false // Is the object being dragged?
        this.rollover = false // Is the mouse over the ellipse?
        this.removed = false

        this.id = ident
        this.id_activity = ident_activity
        this.external = external
        this.parent_name = parent_name

        this.x = x;
        this.y = y;
        // Dimensions
        this.w = this.BUBBLE__WIDTH;
        this.h = this.BUBBLE__HEIGHT
        this.name = name
        this.purpose = purpose
        this.x_hook = -1000
        this.y_hook = -1000
        this.x_remove = -1000
        this.y_remove = -1000
        this.x_start_move_hook = -1000
        this.y_start_move_hook = -1000
        this.curve_radius = 20

        this.preview = this.controller.previewValue
    }

    removeExternal() {
        console.log('ProcessDiagram#removeExternal' + this.id)

        fetch("/bubbles/" + this.id + '/remove', {
            headers: {
                Accept: "text/vnd.turbo-stream.html"
            }
        })
            .then(r => r.text())
            .then(html => Turbo.renderStreamMessage(html))
    }

    move(x, y) {
        this.x = x
        this.y = y
    }


    is_rollover() {
        return this.rollover
    }

    is_removed() {
        return this.removed
    }

    current_x() {
        return this.x
    }

    current_y() {
        return this.y
    }


    over() {
        if (this.removed) {
            return
        }

        // Is mouse over object
        if (this.within_hook(this.x_hook, this.y_hook)) {
            this.rollover = true;
        } else {
            this.rollover = false;
        }

    }

    update() {

        // Adjust location if being dragged
        if (this.dragging) {
            this.x = this.myCanvas.mouseX + this.offsetX;
            this.y = this.myCanvas.mouseY + this.offsetY;
        }

    }

    show(controller) {
        let wanting_to_save = controller.isSaveImage()
        let connection_start = controller.bubble_start

        if (this.removed) {
            return
        }

        this.myCanvas.rectMode(this.myCanvas.CENTER);
        this.myCanvas.push()
        this.myCanvas.strokeWeight(2);
        // Different fill based on state

        if (this.dragging) {
            this.myCanvas.strokeWeight(4);
            this.myCanvas.fill(255, 200, 200);
        } else if (this.rollover) {
            this.myCanvas.stroke(255, 20, 20)
            this.myCanvas.fill(255, 200, 200);
            this.myCanvas.strokeWeight(4)
        } else {
            this.myCanvas.strokeWeight(2);
            this.myCanvas.fill('white');
        }

        if (this.external) {
            this.myCanvas.stroke(100)
            this.myCanvas.drawingContext.setLineDash([10, 5, 2, 5]);
        }
        // this.myCanvas.rect(this.x, this.y, this.w, this.h, 20);

        this.controller.draw_square(this.x, this.y, this.h, this.w, this.curve_radius)
        this.myCanvas.pop()

        this.draw_bubble_background()


        this.myCanvas.push()
        // this.myCanvas.stroke(0);
        this.myCanvas.fill(0);
        this.myCanvas.textAlign(this.myCanvas.CENTER, this.myCanvas.CENTER);
        this.myCanvas.textWrap(this.myCanvas.WORD);
        this.myCanvas.text(this.name, this.x, this.y, this.BUBBLE__TEXT_WIDTH)

        if (this.controller.editingValue && !wanting_to_save) {
            this.myCanvas.fill('white');
            this.x_hook = this.x - 40
            this.y_hook = this.y + 40
            this.arrows(this.x_hook, this.y_hook)

            if (this.external) {
                this.myCanvas.fill('white');
                this.x_remove = this.x + 40
                this.y_remove = this.y + 40
                this.myCanvas.line(this.x_remove - 5, this.y_remove - 5, this.x_remove + 5, this.y_remove + 5)
                this.myCanvas.line(this.x_remove + 5, this.y_remove - 5, this.x_remove - 5, this.y_remove + 5)
            }
            //moving button position
            this.x_start_move_hook = this.x + 20
            this.y_start_move_hook = this.y + 40

            if (!this.external && (this.controller.bubble_move_start === this.id || !this.controller.bubble_move_start)) {
                this.start_move_button(this.x_start_move_hook, this.y_start_move_hook)
            }

            if (this.controller.bubble_move_start && (this.controller.bubble_move_start !== this.id) &&
                (this.purpose === 'diagram')) {
                this.end_move_button(wanting_to_save)
            }
        }
        this.myCanvas.pop()
        if (!controller.bubble_start || this.id === controller.bubbles_new[controller.bubble_start].id) {
            this.connector_hook(wanting_to_save, connection_start);
            //put a hook in bottom right of diagram
            this.external_hook(wanting_to_save);
        }
        if (controller.bubble_start) {
            this.end_connector_hook(wanting_to_save, connection_start);
        }
        return this.rollover
    }

    show_external_hook() {
        if (this.removed) {
            return
        }
        if (this.controller.editingValue) {
            if (this.start_of_connection()) {
                return true
            }
            return false
        }
    }

    external_hook(wanting_to_save) {
        if (this.show_external_hook()) {
            if (this.controller.editingValue && !wanting_to_save) {
                this.myCanvas.push()
                this.myCanvas.stroke(100)
                this.myCanvas.drawingContext.setLineDash([10, 5, 2, 5]);
                this.y_connect = this.controller.external_hook_y
                this.x_connect = this.controller.external_hook_x

                this.controller.draw_square(this.x_connect, this.y_connect, 30, 30, 5)

                this.myCanvas.translate(this.x_connect, this.y_connect)
                this.myCanvas.line(5, -5, 5, 5)
                this.myCanvas.line(-5, 0, 5, 0)
                this.myCanvas.line(5, 0, -2, -5)
                this.myCanvas.line(5, 0, -2, 5)
                this.myCanvas.pop()
            }
        }
    }

    connector_hook(wanting_to_save, connection_start) {
        this.myCanvas.push()
        if (this.start_of_connection()) {
            this.myCanvas.stroke('green')
        }

        if (this.controller.editingValue && !wanting_to_save) {
            this.y_connect = this.y + 40

            if (!this.external) {
                this.myCanvas.translate(this.x - 20, this.y_connect)
                this.myCanvas.line(-5, -5, -5, 5)
                this.myCanvas.line(-5, 0, 5, 0)
                this.myCanvas.line(5, 0, -2, -5)
                this.myCanvas.line(5, 0, -2, 5)
            }
        }
        this.myCanvas.pop()
    }

    end_connector_hook(wanting_to_save, connection_start) {
        this.myCanvas.push()
        if (this.controller.editingValue && !wanting_to_save) {
            this.y_connect = this.y + 40
            this.myCanvas.translate(this.x, this.y_connect)
            this.myCanvas.line(5, -5, 5, 5)
            this.myCanvas.line(-5, 0, 5, 0)
            this.myCanvas.line(5, 0, -2, -5)
            this.myCanvas.line(5, 0, -2, 5)
        }
        this.myCanvas.pop()
    }


    arrows(x, y) {
        this.myCanvas.push()
        this.myCanvas.noFill()
        this.myCanvas.strokeWeight(1);
        this.myCanvas.stroke(0)

        this.myCanvas.line(x - 3, y + 4, x, y + 6)
        this.myCanvas.line(x, y + 6, x + 3, y + 4)
        this.myCanvas.line(x - 3, y - 4, x, y - 6)
        this.myCanvas.line(x, y - 6, x + 3, y - 4)
        this.myCanvas.line(x + 4, y - 3, x + 6, y)
        this.myCanvas.line(x + 6, y, x + 4, y + 3)
        this.myCanvas.line(x - 4, y + 3, x - 6, y)
        this.myCanvas.line(x - 6, y, x - 4, y - 3)
        this.myCanvas.pop()
    }

    start_move_button(x, y) {
        //todo make a different shape
        this.myCanvas.push()
        this.myCanvas.strokeWeight(1);

        if (this.start_of_move()) {
            this.myCanvas.stroke('green')
        } else {
            this.myCanvas.stroke('black')
        }

        this.myCanvas.translate(x, y)
        this.myCanvas.line(-7, -4, -7, 4)
        this.myCanvas.line(-7, 4, -1, 4)
        this.myCanvas.line(-1, 4, -1, -4)
        this.myCanvas.line(-1, -4, -7, -4)

        this.myCanvas.stroke('gray')

        this.myCanvas.line(7, -4, 7, 4)
        this.myCanvas.line(7, 4, 1, 4)
        this.myCanvas.line(1, 4, 1, -4)
        this.myCanvas.line(1, -4, 7, -4)

        // this.myCanvas.line(-3, 0, 5, 0)
        // this.myCanvas.line(5, 0, 2, -5)
        // this.myCanvas.line(5, 0, 2, 5)

        this.myCanvas.pop()
    }

    end_move_button(wanting_to_save) {
        //todo make a different shape
        this.myCanvas.push()
        this.myCanvas.strokeWeight(1);

        if (this.controller.editingValue && !wanting_to_save) {
            let x = this.x_start_move_hook + 20
            let y = this.y_start_move_hook

            this.myCanvas.stroke('gray')

            this.myCanvas.translate(x, y)
            this.myCanvas.line(-7, -4, -7, 4)
            this.myCanvas.line(-7, 4, -1, 4)
            this.myCanvas.line(-1, 4, -1, -4)
            this.myCanvas.line(-1, -4, -7, -4)

            this.myCanvas.stroke('black')

            this.myCanvas.line(7, -4, 7, 4)
            this.myCanvas.line(7, 4, 1, 4)
            this.myCanvas.line(1, 4, 1, -4)
            this.myCanvas.line(1, -4, 7, -4)

        }
        this.myCanvas.pop()
    }

    draw_bubble_background() {
        this.myCanvas.push()
        this.myCanvas.fill(255, 240, 240);
        this.myCanvas.stroke(255, 200, 200)
        if (this.purpose == 'diagram') {
            this.myCanvas.line(this.x - 20, this.y - 15, this.x + 20, this.y - 15)
            this.myCanvas.line(this.x + 20, this.y - 15, this.x + 20, this.y + 15)
            this.myCanvas.line(this.x - 20, this.y - 15, this.x + 20, this.y + 15)
            this.myCanvas.line(this.x + 20, this.y + 15, this.x - 20, this.y - 15)
            this.myCanvas.rect(this.x - 20, this.y - 15, this.w / 4, this.h / 4, 20 / 5)
            this.myCanvas.rect(this.x + 20, this.y + 15, this.w / 4, this.h / 4, 20 / 5)
        } else if (this.purpose == 'steps') {
            this.myCanvas.strokeWeight(6);
            this.myCanvas.line(this.x - 20, this.y - 15, this.x - 18, this.y - 15)
            this.myCanvas.line(this.x - 20, this.y - 5, this.x - 18, this.y - 5)
            this.myCanvas.line(this.x - 20, this.y + 5, this.x - 18, this.y + 5)
            this.myCanvas.line(this.x - 20, this.y + 15, this.x - 18, this.y + 15)
            this.myCanvas.line(this.x - 10, this.y - 15, this.x + 20, this.y - 15)
            this.myCanvas.line(this.x - 10, this.y - 5, this.x + 20, this.y - 5)
            this.myCanvas.line(this.x - 10, this.y + 5, this.x + 20, this.y + 5)
            this.myCanvas.line(this.x - 10, this.y + 15, this.x + 20, this.y + 15)
            this.myCanvas.strokeWeight(4);
        }
        this.myCanvas.pop()
    }

    start_of_connection() {
        if (this.controller.bubble_start == null) {
            return false
        }

        if (this.controller.bubbles_new[this.controller.bubble_start].id === this.id) {
            return true
        }
    }

    start_of_move() {
        if (this.controller.bubble_move_start == null) {
            return false
        }

        if (this.controller.bubbles_new[this.controller.bubble_move_start].id === this.id) {
            return true
        }
    }

    clicked_move_start() {
        if (this.removed) {
            return
        }
        if (this.controller.editingValue) {
            if (this.within_hook(this.x_start_move_hook, this.y_start_move_hook)) {
                if (this.start_of_move()) {
                    this.controller.bubble_move_start = null
                } else {
                    return true
                }
            }
            return false
        }
    }

    clicked_move_end() {
        if (this.removed) {
            return
        }

        if (this.controller.bubble_move_start === this.id) {
            return
        }

        if (this.controller.editingValue) {
            if (this.within_hook(this.x_start_move_hook + 20, this.y_start_move_hook)) {
                return true
            }
        }
    }

    clicked_start() {
        if (this.removed) {
            return
        }

        if (this.controller.editingValue) {
            if (this.within_hook(this.x - 20, this.y_connect)) {
                if (this.start_of_connection()) {
                    this.controller.bubble_start = null
                } else {
                    return true
                }
            }
            return false
        }
    }

    clicked_end() {
        if (this.removed) {
            return
        }
        if (this.controller.editingValue) {
            if (this.within_hook(this.x, this.y_connect)) {
                return true
            }
        }
    }

    pressed() {
        if (this.removed) {
            return
        }

        if (this.preview) {
            return
        }

        // Did I click on the rectangle?
        if (this.within_bubble() && !this.controller.changingValue) {
            this.grabbed = true
            this.controller.changingValue = true
            this.url = `/activities/${this.id_activity}`
            fetch(this.url, {
                headers: {
                    Accept: "text/vnd.turbo-stream.html"
                }
            })
                .then(r => r.text())
                .then(html => Turbo.renderStreamMessage(html))
        } else if (this.within_hook(this.x_remove, this.y_remove)) {
            this.removeExternal()
        }

        if (this.controller.editingValue) {
            if (this.within_hook(this.x_hook, this.y_hook)) {
                this.dragging = true;
                // If so, keep track of relative location of click to corner of rectangle
                this.offsetX = this.x - this.myCanvas.mouseX;
                this.offsetY = this.y - this.myCanvas.mouseY;
            }
        }
    }

    released() {
        if (this.dragging) {
            // Quit dragging
            this.dragging = false;

            Rails.ajax({
                type: 'PUT',
                url: `/bubbles/${this.id}`,
                dataType: 'html',
                data: "x=" + `${this.x}` + "&y=" + `${this.y}`,
                success: function (response) {
                },
                error: function (response) {
                }
            })
        }
    }

    remove() {
        this.removed = true
    }

    within_bubble() {
        if (this.myCanvas.mouseX < (this.x - this.BUBBLE__WIDTH / 2)) {
            return false
        }
        if (this.myCanvas.mouseX > (this.x + this.BUBBLE__WIDTH / 2)) {
            return false
        }
        if (this.myCanvas.mouseY < (this.y - this.BUBBLE__HEIGHT / 2)) {
            return false
        }
        return this.myCanvas.mouseY <= (this.y + this.BUBBLE__HEIGHT / 2);

    }

    within_hook(x, y) {
        if (this.myCanvas.mouseX < (x - 10)) {
            return false
        }
        if (this.myCanvas.mouseX > (x + 10)) {
            return false
        }
        if (this.myCanvas.mouseY < (y - 10)) {
            return false
        }
        if (this.myCanvas.mouseY > (y + 10)) {
            return false
        }
        return true
    }

}

class Connector {
    constructor(myCanvas, b1, b2, style, id, height, direction, hidden, controller) {
        this.controller = controller

        this.CURVE_RADIUS = 40

        this.myCanvas = myCanvas
        this.b1 = b1
        this.b2 = b2
        this.style = style
        this.bubbles = controller.bubbles_new
        this.id = id
        this.height = height
        this.below_line = direction
        this.hidden = hidden

        this.rollover = false
        this.grabbed = false
        this.x_hook = -1000
        this.y_hook = -1000

        this.x_remove_hook = -1100
        this.y_remove_hook = -1100

        this.x_cancel_remove_hook = this.controller.external_hook_x - 15
        this.y_cancel_remove_hook = this.controller.external_hook_y

        this.secL = this.myCanvas.random(0.2, 0.4);
        this.rand1 = this.myCanvas.random(-1.0, 1.0)
        this.rand2 = this.myCanvas.random(-1.0, 1.0)
        this.rand3 = this.myCanvas.random(-1.0, 1.0)
        this.rand4 = this.myCanvas.random(-1.0, 1.0)
    }

    over() {
        // Is mouse over object
        this.rollover = this.within_arrow() || this.within_remove_btn();
    }

    update() {
        // Adjust location if being dragged
        if (this.dragging) {
            this.x = this.myCanvas.mouseX + this.offsetX;
            this.y = this.myCanvas.mouseY + this.offsetY;
        }
    }

    styling(style, direction, height, hidden) {
        this.style = style
        this.below_line = direction
        this.height = height
        this.hidden = hidden
    }

    remove() {
        this.removed = true
    }

    show(wanting_to_save) {
        if (this.removed) {
            return
        }
        let b_from = this.bubbles[this.b1]
        let b_to = this.bubbles[this.b2]

        if ((b_from && b_from.is_removed()) || (b_to && b_to.is_removed())) {
            return
        }

        this.myCanvas.push()

        if (this.hidden) {
            this.myCanvas.drawingContext.setLineDash([2, 2]);
        }

        if (this.rollover) {
            this.myCanvas.stroke(255, 20, 20)
            this.myCanvas.strokeWeight(3)
        }
        if (this.id === this.controller.remove_connector_id) {
            this.myCanvas.stroke(255, 20, 20)
            this.myCanvas.strokeWeight(3)
            this.confirm_remove_hook(wanting_to_save)
        }

        if (b_from && b_from.is_rollover()) {
            this.myCanvas.stroke(255, 20, 20)
            this.myCanvas.strokeWeight(3)
        }

        if (b_to && b_to.is_rollover()) {
            this.myCanvas.stroke(255, 20, 20)
            this.myCanvas.strokeWeight(3)
        }

        let x_from = this.bubbles[this.b1] ? this.bubbles[this.b1].current_x() : this.x1
        let y_from = this.bubbles[this.b1] ? this.bubbles[this.b1].current_y() : this.y1
        let x_to = this.bubbles[this.b2] ? this.bubbles[this.b2].current_x() : this.x2
        let y_to = this.bubbles[this.b2] ? this.bubbles[this.b2].current_y() : this.y2

        if (this.b1 == this.b2) {
            this.myCanvas.ellipse(x_from + 60, y_from + 30, 70, 40)

            this.arrow(
                x_from + 70, y_from + 10,
                x_from + 50, y_from + 10
            )

        } else if (this.style == 'optional-after') {
            let x_offset_end = (x_from > x_to ? -10 : 10)
            let x_curve = (x_from > x_to ? this.CURVE_RADIUS - x_offset_end : -this.CURVE_RADIUS - x_offset_end)
            let y_curve = (y_from > y_to ? -this.CURVE_RADIUS : this.CURVE_RADIUS)
            let x_edge = (x_from < x_to ? x_from + 100 / 2 : x_from - 100 / 2)
            let y_edge = (y_from < y_to ? y_to - 55 / 2 : y_to + 55 / 2)

            this.myCanvas.push()
            this.myCanvas.noFill();
            this.myCanvas.beginShape()
            this.vertex_wobble(x_edge, y_from, x_to + x_curve, y_from)
            this.myCanvas.bezierVertex(
                x_to - x_offset_end, y_from,
                x_to - x_offset_end, y_from,
                x_to - x_offset_end, y_from + y_curve);
            this.vertex_wobble(x_to - x_offset_end, y_from + y_curve, x_to - x_offset_end, y_edge)
            this.myCanvas.endShape()
            this.myCanvas.pop()


            this.arrow_with_hook(
                x_edge, y_from,
                x_to + x_curve, y_from,
                wanting_to_save
            )

            this.remove_hook(
                x_edge, y_from,
                x_to + x_curve, y_from,
                wanting_to_save
            )

            this.arrow(
                x_to - x_offset_end, y_from + y_curve,
                x_to - x_offset_end, y_edge
            )
        } else if (this.style == 'optional') {

            let x_offset_start = (x_from > x_to ? -10 : 10)
            let x_curve = (x_from > x_to ? -50 : 50)
            let y_curve = (y_from > y_to ? 40 : -40)
            let x_edge_end = (x_from < x_to ? x_to + x_offset_start - 100 / 2 : x_to + x_offset_start + 100 / 2)
            let y_edge = (y_from > y_to ? y_from - 55 / 2 : y_from + 55 / 2)

            this.myCanvas.push()
            this.myCanvas.noFill();
            this.myCanvas.beginShape()
            this.vertex_wobble(x_from + x_offset_start, y_edge, x_from + x_offset_start, y_to + y_curve)
            this.myCanvas.bezierVertex(x_from + x_offset_start, y_to, x_from + x_offset_start, y_to, x_from + x_curve, y_to);
            this.vertex_wobble(x_from + x_curve, y_to, x_edge_end, y_to)
            this.myCanvas.endShape()
            this.myCanvas.pop()


            // Vertical Arrow
            this.arrow(
                x_from + x_offset_start, y_edge,
                x_from + x_offset_start, y_to + y_curve
            )

            this.arrow_with_hook(
                x_from + x_curve, y_to,
                x_edge_end, y_to,
                wanting_to_save
            )

            this.remove_hook(
                x_from + x_curve, y_to,
                x_edge_end, y_to,
                wanting_to_save
            )


        } else if (this.style == 'over') {
            let total_height = (this.below_line ? +50 + this.height * 50 : -50 - this.height * 50)
            let y_top
            if (this.below_line) {
                y_top = (y_from > y_to ? y_from + total_height : y_to + total_height)
            } else {
                y_top = (y_from < y_to ? y_from + total_height : y_to + total_height)
            }
            let x_offset_start = (x_from > x_to ? -10 : 10)
            let x_curve = (x_from > x_to ? -50 : 50)
            let y_curve = (this.below_line ? -40 : 40)

            this.myCanvas.push()
            this.myCanvas.noFill();
            this.myCanvas.beginShape()
            this.vertex_wobble(x_from, y_from, x_from, y_top + y_curve)
            this.myCanvas.bezierVertex(x_from, y_top, x_from, y_top, x_from + x_curve, y_top);
            this.vertex_wobble(x_from + x_curve, y_top, x_to - x_curve, y_top)
            this.myCanvas.bezierVertex(x_to + x_offset_start, y_top, x_to + x_offset_start, y_top, x_to + x_offset_start, y_top + y_curve);
            this.vertex_wobble(x_to + x_offset_start, y_top + y_curve, x_to + x_offset_start, y_to)
            this.myCanvas.endShape()
            this.myCanvas.pop()

            this.arrow_with_hook(x_from, y_top,
                x_to, y_top,
                wanting_to_save
            )

            this.remove_hook(x_from, y_top,
                x_to, y_top,
                wanting_to_save
            )

        } else if (this.style == 'curve') {

            let x_mid = (x_from + x_to) / 2.0
            let y_mid = (y_from + y_to) / 2.0

            this.myCanvas.push()
            this.myCanvas.noFill()
            this.myCanvas.beginShape();
            this.myCanvas.curveVertex(x_from, y_from)
            this.myCanvas.curveVertex(x_from, y_from)
            this.myCanvas.curveVertex(
                x_mid + (y_to - y_from) * 0.13,
                y_mid + (x_from - x_to) * 0.13
            )
            this.myCanvas.curveVertex(x_to, y_to)
            this.myCanvas.curveVertex(x_to, y_to)
            this.myCanvas.endShape();
            this.myCanvas.pop()

            this.arrow_with_hook(
                x_from + (y_to - y_from) * 0.13,
                y_from + (x_from - x_to) * 0.13,
                x_to + (y_to - y_from) * 0.13,
                y_to + (x_from - x_to) * 0.13,
                wanting_to_save
            )

            this.remove_hook(
                x_from + (y_to - y_from) * 0.13,
                y_from + (x_from - x_to) * 0.13,
                x_to + (y_to - y_from) * 0.13,
                y_to + (x_from - x_to) * 0.13,
                wanting_to_save
            )
        } else {
            if (this.bubbles[this.b1]) {
                this.myCanvas.push()
                this.myCanvas.beginShape()
                this.vertex_wobble(
                    x_from,
                    y_from,
                    x_to,
                    y_to
                )
                this.myCanvas.endShape()

                this.arrow_with_hook(
                    x_from,
                    y_from,
                    x_to,
                    y_to,
                    wanting_to_save
                )

                this.remove_hook(
                    x_from,
                    y_from,
                    x_to,
                    y_to,
                    wanting_to_save
                )
                this.myCanvas.pop()
            }
        }
        this.myCanvas.pop()

        return this.rollover
    }


    vertex_wobble(x_from, y_from, x_to, y_to) {
        let dLen = this.myCanvas.dist(x_from, y_from, x_to, y_to) * 0.03;
        let trdL = this.secL * 2.0;

        let x_mid = (x_from + x_to) / 2
        let y_mid = (y_from + y_to) / 2

        this.myCanvas.vertex(x_from, y_from);
        this.myCanvas.bezierVertex(
            this.myCanvas.lerp(x_from, x_mid, this.secL) + this.rand1 * dLen,
            this.myCanvas.lerp(y_from, y_mid, this.secL) + this.rand2 * dLen,
            this.myCanvas.lerp(x_from, x_mid, trdL) + this.rand3 * dLen,
            this.myCanvas.lerp(y_from, y_mid, trdL) + this.rand4 * dLen,
            x_mid,
            y_mid
        );
        this.myCanvas.bezierVertex(
            this.myCanvas.lerp(x_mid, x_to, trdL) - this.rand4 * dLen,
            this.myCanvas.lerp(y_mid, y_to, trdL) - this.rand3 * dLen,
            this.myCanvas.lerp(x_mid, x_to, this.secL) - this.rand2 * dLen,
            this.myCanvas.lerp(y_mid, y_to, this.secL) - this.rand1 * dLen,
            x_to,
            y_to
        );
    }

    pressed() {
        if (this.controller.editingValue) {
            if (this.grabbed === true) {
                return
            } // Don't keep pressing

            // Did I click on the connector?
            if (this.within_arrow()) {
                this.grabbed = true
                this.controller.changingValue = true

                this.url = `/bubble_connectors/${this.id}/edit`
                fetch(this.url, {
                    headers: {
                        Accept: "text/vnd.turbo-stream.html"
                    }
                })
                    .then(r => r.text())
                    .then(html => Turbo.renderStreamMessage(html))
            } else if (this.within_remove_btn() && this.is_connector_to_remove()) {
                this.controller.remove_connector_id = null
            } else if (this.within_remove_btn()) {
                this.controller.remove_connector_id = this.id
                this.controller.bubble_start = null
                this.controller.bubble_move_start = null

            } else if (this.within_confirm_remove_btn() && this.is_connector_to_remove()) {
                this.url = `/bubble_connectors/${this.id}`
                fetch(this.url, {
                    method: 'DELETE',
                    headers: {
                        Accept: "text/vnd.turbo-stream.html",
                        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
                    }
                })
                    .then(r => r.text())
                    .then(html => Turbo.renderStreamMessage(html))
            }

            if (this.within_remove_btn()) {
                return true
            }
            return false
        }
    }

    is_connector_to_remove() {
        if (this.id === this.controller.remove_connector_id) {
            return true
        }
        return false
    }

    within_confirm_remove_btn() {
        if (this.myCanvas.mouseX < (this.x_cancel_remove_hook - 65)) {
            return false
        }
        if (this.myCanvas.mouseX > (this.x_cancel_remove_hook + 25)) {
            return false
        }
        if (this.myCanvas.mouseY < (this.y_cancel_remove_hook - 10)) {
            return false
        }
        if (this.myCanvas.mouseY > (this.y_cancel_remove_hook + 10)) {
            return false
        }
        return true
    }

    show_confirm_remove_hook() {
        if (this.removed) {
            return
        }
        if (this.controller.editingValue) {
            if (this.id === this.controller.remove_connector_id) {
                return true
            }
            return false
        }
    }

    confirm_remove_hook(wanting_to_save) {
        if (this.show_confirm_remove_hook()) {
            if (this.controller.editingValue && !wanting_to_save) {
                this.myCanvas.push()

                this.y_connect = this.y_cancel_remove_hook
                this.x_connect = this.x_cancel_remove_hook

                this.myCanvas.stroke(0)
                this.myCanvas.strokeWeight(0)
                this.myCanvas.fill(0);

                this.myCanvas.text("Confirm Delete", this.x_cancel_remove_hook - 52, this.y_cancel_remove_hook + 2)
                this.myCanvas.pop()


                this.myCanvas.push()
                this.myCanvas.stroke(100)
                this.myCanvas.drawingContext.setLineDash([10, 5, 2, 5]);

                this.controller.draw_square(this.x_connect - 15, this.y_connect, 30, 90, 5)

                this.myCanvas.translate(this.x_connect, this.y_connect)


                this.myCanvas.pop()
            }
        }
    }

    released() {
        this.grabbed = false
    }

    within_arrow() {

        if (this.myCanvas.mouseX < (this.x_hook - 10)) {
            return false
        }
        if (this.myCanvas.mouseX > (this.x_hook + 10)) {
            return false
        }
        if (this.myCanvas.mouseY < (this.y_hook - 10)) {
            return false
        }
        if (this.myCanvas.mouseY > (this.y_hook + 10)) {
            return false
        }
        return true
    }

    within_remove_btn() {

        if (this.myCanvas.mouseX < (this.x_remove_hook - 10)) {
            return false
        }
        if (this.myCanvas.mouseX > (this.x_remove_hook + 10)) {
            return false
        }
        if (this.myCanvas.mouseY < (this.y_remove_hook - 10)) {
            return false
        }
        if (this.myCanvas.mouseY > (this.y_remove_hook + 10)) {
            return false
        }
        return true
    }

    arrow_with_hook(x_from, y_from, x_to, y_to, wanting_to_save) {
        this.arrow(x_from, y_from, x_to, y_to)

        if (this.controller.editingValue && !this.controller.changingValue) {
            this.x_hook = (x_to + x_from) / 2
            this.y_hook = (y_to + y_from) / 2 + 20

            if (this.rollover) {
                this.myCanvas.fill(255, 200, 200)
            } else {
                this.myCanvas.noFill()
            }
            this.myCanvas.circle(
                this.x_hook,
                this.y_hook,
                10
            )
        }
    }

    remove_hook(x_from, y_from, x_to, y_to, wanting_to_save) {

        if (this.controller.editingValue && !this.controller.changingValue) {

            this.x_remove_hook = (x_to + x_from) / 2 + 20
            this.y_remove_hook = (y_to + y_from) / 2 + 20

            if (this.rollover) {
                this.myCanvas.fill(255, 200, 200)
            } else {
                this.myCanvas.noFill()
            }

            this.remove_connector_btn(this.x_remove_hook, this.y_remove_hook)


        }
    }

    remove_connector_btn(x, y) {
        this.myCanvas.fill('white');
        this.x_remove = x
        this.y_remove = y
        this.myCanvas.line(this.x_remove - 5, this.y_remove - 5, this.x_remove + 5, this.y_remove + 5)
        this.myCanvas.line(this.x_remove + 5, this.y_remove - 5, this.x_remove - 5, this.y_remove + 5)
    }

    arrow(x_from, y_from, x_to, y_to) {
        this.myCanvas.push()
        this.myCanvas.fill('white')

        let norm = this.myCanvas.createVector(
            x_to - x_from,
            y_to - y_from)

        norm.normalize()
        this.myCanvas.translate(
            (x_to + x_from) / 2,
            (y_to + y_from) / 2)

        // applyMatrix(1,0,0,1,vector.x - start.x,vector.y - start.y)
        this.myCanvas.applyMatrix(norm.x, norm.y, -norm.y, norm.x, 0, 0)
        this.myCanvas.triangle(-5, 3, 7, 0, -5, -3)
        this.myCanvas.pop()
    }
}


// Connects to data-controller="process-diagram"
export default class extends Controller {
    static values = {
        id: Number,
        bubbles: Object,
        connectors: Array,
        followers: String,
        editing: Boolean,
        needsSaving: Boolean,
        changing: Boolean,
        preview: Boolean
    }

    static targets = ['loading']

    connect() {
        this.bubble_text = {}
        this.bubble = {}
        this.bubbles_new = []
        this.connectors_new = []
        this.remove_connector_id = null

        this.connectors = {}
        this.connector_arrows = {}
        this.edit_buttons = {}

        this.external_hook_x = 980
        this.external_hook_y = 480

        this.sketch = this.sketch_idnameofdiv(this)
        if (this.previewValue === true) {
            this.myCanvas = new p5(this.sketch, "myContainer_preview_" + this.idValue)
        } else {
            this.myCanvas = new p5(this.sketch, "myContainer_" + this.idValue)
        }
        // this.myCanvas.freddie = "hello"

        this.secL = this.myCanvas.random(0.2, 0.4);
        this.rand1 = this.myCanvas.random(-1.0, 1.0)
        this.rand2 = this.myCanvas.random(-1.0, 1.0)
        this.rand3 = this.myCanvas.random(-1.0, 1.0)
        this.rand4 = this.myCanvas.random(-1.0, 1.0)

        this.haveDrawn = false
        this.haveData = false

        this.draw(true)
        // this.subscription()
    }

    draw_square(x, y, h, w, curve_radius) {
        this.myCanvas.beginShape()

        this.vertex_wobble(
            x - w / 2 + curve_radius, y - h / 2,
            x + w / 2 - curve_radius, y - h / 2)
        this.myCanvas.bezierVertex(
            x + w / 2, y - h / 2,
            x + w / 2, y - h / 2,
            x + w / 2, y + curve_radius)
        this.vertex_wobble(x + w / 2, y + curve_radius, x + w / 2, y + h / 2 - curve_radius)
        this.myCanvas.bezierVertex(
            x + w / 2, y + h / 2,
            x + w / 2, y + h / 2,
            x + w / 2 - curve_radius, y + h / 2)

        // Bottom Edge
        this.vertex_wobble(
            x + w / 2 - curve_radius, y + h / 2,
            x + curve_radius, y + h / 2)
        this.myCanvas.bezierVertex(
            x - w / 2, y + h / 2,
            x - w / 2, y + h / 2,
            x - w / 2, y + h / 2 - curve_radius)
        this.vertex_wobble(
            x - w / 2, y + h / 2 - curve_radius,
            x - w / 2, y - h / 2 + curve_radius)

        this.myCanvas.bezierVertex(
            x - w / 2, y - h / 2,
            x - w / 2, y - h / 2,
            x - w / 2 + curve_radius, y - h / 2)

        this.myCanvas.endShape()
    }


    vertex_wobble(x_from, y_from, x_to, y_to) {
        let dLen = this.myCanvas.dist(x_from, y_from, x_to, y_to) * 0.03;
        let trdL = this.secL * 2.0;

        let x_mid = (x_from + x_to) / 2
        let y_mid = (y_from + y_to) / 2

        this.myCanvas.vertex(x_from, y_from);
        this.myCanvas.bezierVertex(
            this.myCanvas.lerp(x_from, x_mid, this.secL) + this.rand1 * dLen,
            this.myCanvas.lerp(y_from, y_mid, this.secL) + this.rand2 * dLen,
            this.myCanvas.lerp(x_from, x_mid, trdL) + this.rand3 * dLen,
            this.myCanvas.lerp(y_from, y_mid, trdL) + this.rand4 * dLen,
            x_mid,
            y_mid
        );
        this.myCanvas.bezierVertex(
            this.myCanvas.lerp(x_mid, x_to, trdL) - this.rand4 * dLen,
            this.myCanvas.lerp(y_mid, y_to, trdL) - this.rand3 * dLen,
            this.myCanvas.lerp(x_mid, x_to, this.secL) - this.rand2 * dLen,
            this.myCanvas.lerp(y_mid, y_to, this.secL) - this.rand1 * dLen,
            x_to,
            y_to
        );
    }

    notChanging() {

        this.changingValue = false
        this.bubble_start = null
        this.bubble_end = null
    }

    isChanging() {

        this.changingValue = true
        this.bubble_start = null
        this.bubble_end = null
    }

    disconnect() {
        this.myCanvas.remove()
    }

    connectors() {
        return this.connectors_new
    }

    sketch_idnameofdiv(that) {
        let i

        let add_connector = function () {
            that.bubble_start = null
            that.bubble_end = null
        }

        return function (p) {

            p.setup = function () {
                // let bounding = document.getElementById(`myContainer`).getBoundingClientRect()
                p.createCanvas(1000, 500);
                p.textSize(11);
                p.frameRate(10);
            }

            p.draw = function () {
                let rollOver = false
                p.background('white');
                // this.can_save = true

                that.myCanvas.noFill()

                for (i in that.connectors_new) {
                    rollOver = that.connectors_new[i].show(that.isSaveImage()) || rollOver
                }

                for (i in that.bubbles_new) {
                    rollOver = that.bubbles_new[i].show(that) || rollOver
                }

                // if (!rollOver) {
                //     that.send_image()
                // }

                if (that.haveData) {
                    that.haveDrawn = true
                    that.loadingTarget.innerHTML = "<div id='loaded'></div>";
                }

            }

            p.mouseMoved = function () {
                if (that.changingValue) {
                    return
                }
                for (i in that.connectors_new) {
                    that.connectors_new[i].over()
                }

                for (i in that.bubbles_new) {
                    that.bubbles_new[i].over()
                }

            }

            p.mouseClicked = function () {
                if (that.changingValue) {
                    return
                }
                let i

                for (i in that.bubbles_new) {

                    if (that.bubbles_new[i].clicked_start()) {
                        that.bubble_start = that.bubbles_new[i].id
                    }
                    if (that.bubbles_new[i].clicked_end()) {
                        that.bubble_end = that.bubbles_new[i].id
                    }

                    if (that.bubbles_new[i].clicked_move_start()) {
                        that.bubble_move_start = that.bubbles_new[i].id
                    }
                    if (that.bubbles_new[i].clicked_move_end()) {
                        that.bubble_move_end = that.bubbles_new[i].id
                    }
                }

                if (that.bubble_start && that.bubble_end) {
                    // Write this back to the server
                    this.url = `/bubbles/${that.bubbles_new[that.bubble_start].id}/following_to?follower_id=${that.bubbles_new[that.bubble_end].id}`

                    fetch(this.url, {
                        headers: {
                            Accept: "text/vnd.turbo-stream.html"
                        }
                    })
                        .then(r => r.text())
                        .then(html => Turbo.renderStreamMessage(html))
                        .then(r => add_connector())

                    that.bubble_start = null
                    that.bubble_end = null
                } else if (that.bubble_start && that.within_external_hook(that.external_hook_x, that.external_hook_y)) {

                    that.changingValue = true
                    this.url = `/activities/${that.bubbles_new[that.bubble_start].id_activity}/get_follow_modal`
                    fetch(this.url, {
                        headers: {
                            Accept: "text/vnd.turbo-stream.html"
                        }
                    })
                        .then(r => r.text())
                        .then(html => Turbo.renderStreamMessage(html))
                }
                if (that.bubble_move_start && that.bubble_move_end) {
                    this.url = `/bubbles/${that.bubbles_new[that.bubble_move_start].id}/move?move_to_id=${that.bubbles_new[that.bubble_move_end].id}`

                    fetch(this.url, {
                        headers: {
                            Accept: "text/vnd.turbo-stream.html"
                        }
                    })
                        .then(r => r.text())
                        .then(html => Turbo.renderStreamMessage(html))


                    that.bubble_move_start = null
                    that.bubble_move_end = null
                }
            }

            p.mousePressed = function () {
                if (that.changingValue) {
                    return
                }
                for (i in that.bubbles_new) {
                    that.bubbles_new[i].pressed()
                    // that.bubbles_new[i].clicked()
                }


                this.within_remove = false
                for (i in that.connectors_new) {
                    this.within_remove ||= that.connectors_new[i].pressed()
                }

                if (this.within_remove === false) {
                    that.remove_connector_id = null
                }
            }

            p.mouseDragged = function () {
                if (that.changingValue) {
                    return
                }
                for (i in that.bubbles_new) {
                    that.bubbles_new[i].update()
                }

            }

            p.mouseReleased = function () {
                for (i in that.connectors_new) {
                    that.connectors_new[i].released()
                }

                for (i in that.bubbles_new) {
                    that.bubbles_new[i].released()
                }
            }
        }
    }

    within_external_hook(x, y) {
        if (this.myCanvas.mouseX < (x - 10)) {
            return false
        }
        if (this.myCanvas.mouseX > (x + 10)) {
            return false
        }
        if (this.myCanvas.mouseY < (y - 10)) {
            return false
        }
        if (this.myCanvas.mouseY > (y + 10)) {
            return false
        }
        return true
    }

    isSaveImage() {
        return this.save_image && this.needsSavingValue === true
    }


    send_image() {
        if (this.isSaveImage()) {
            let canvas_img = this.myCanvas.canvas.toDataURL()

            let url = `/activities/${this.idValue}`
            let data = new FormData()
            data.append('activity[diagram_img]', canvas_img)
            Rails.ajax({
                type: 'PATCH',
                url: url,
                dataType: 'json',
                data: data,
                success: function (response) {
                },
                error: function (response) {
                    console.log('IMG save failed')
                }
            })
            this.save_image = false
        }
    }


    subscription() {
        console.log('ProcessDiagram#subscription id:' + this.idValue)

        if (this._subscription == undefined) {
            let that = this
            this._subscription = consumer.subscriptions.create({
                channel: "ProcessDiagramChannel",
                id: that.idValue
            }, {
                connected() {
                    console.log('ProcessDiagram#connected')
                }, disconnected() {
                    console.log('ProcessDiagram#disconnected')
                }, received(data) {
                    // that.changingValue = false;

                    if (data.action === 'style-connector') {
                        that.connectors_new[data.bubble_connector.id].styling(
                            data.bubble_connector.style,
                            data.bubble_connector.line_below,
                            data.bubble_connector.height,
                            data.bubble_connector.hidden)

                    }

                    if (data.action === 'new-connector') {
                        that.connectors_new[data.connector.id] = new Connector(
                            that.myCanvas,
                            data.from_id,
                            data.to_id,
                            data.style,
                            data.connector.id,
                            0,
                            null,
                            false,
                            that)
                    }

                    if (data.action === 'remove-connector') {
                        that.connectors_new[data.bubble_connector.id].remove()
                    }

                    if (data.action === 'refresh-connectors') {
                        let j = null

                        for (j in that.edit_buttons) {
                            that.edit_buttons[j].remove()
                        }
                        that.draw(false)
                    }

                    if (data.action === 'new') {
                        that.draw_bubble(
                            data.bubble.id,
                            data.bubble.x,
                            data.bubble.y,
                            that.drag,
                            data.name,
                            data.activity.id,
                            data.activity.purpose,
                            data.activity.parent_id,
                            data.parent_name);
                    }

                    if (data.action === 'refresh-bubble') {
                        that.bubbles_new[data.bubble.id].move(data.bubble.x, data.bubble.y)
                    }

                    if (data.action === 'remove') {
                        that.bubbles_new[data.bubble.id].remove()
                    }

                    //not being called anywhere
                    if (data.action === 'connector-replace') {
                        that.connectors[data.id]
                            .attr("stroke", "#a88")
                            .attr("d", data.connection.path)
                            .attr("fill", "none").attr("stroke-width", "2px")

                        that.connector_arrows[data.id]
                            .attr("stroke", "#a88")
                            .attr("d", data.connection.arrow)
                            .attr("fill", "none").attr("stroke-width", "2px")

                        if (data.connection.hidden) {
                            that.connectors[data.id].style("stroke-dasharray", ("3, 3"))
                                .attr("marker-mid", "url(#Arrow)")

                            that.connector_arrows[data.id].style("stroke-dasharray", ("3, 3"))
                                .attr("marker-mid", "url(#Arrow)")
                        } else {
                            that.connectors[data.id].style("stroke-dasharray", null)
                                .attr("marker-mid", "url(#Arrow)")

                            that.connector_arrows[data.id].style("stroke-dasharray", null)
                                .attr("marker-mid", "url(#Arrow)")
                        }

                        if (that.editingValue) {
                            console.log(`>> ${data.id}`)

                            that.edit_buttons[data.id].attr("x", data.connection.edit_x)
                                .attr("y", data.connection.edit_y);
                        }
                    }
                },
            })
        }
        return this._subscription
    }

    draw(bubbles) {
        let i = null
        let j
        let that = this

        for (j in that.connectorsValue) {
            if (bubbles) {

                that.connectors_new[that.connectorsValue[j].id] = new Connector(
                    that.myCanvas,
                    that.connectorsValue[j].id_from,
                    that.connectorsValue[j].id_to,
                    that.connectorsValue[j].style,
                    that.connectorsValue[j].id,
                    that.connectorsValue[j].height,
                    that.connectorsValue[j].direction,
                    that.connectorsValue[j].hidden,
                    that
                )
            }
        }

        console.log('shall we draw bubbles')
        if (bubbles) {
            for (i in that.bubblesValue) {

                that.draw_bubble(that.bubblesValue[i].id,
                    that.bubblesValue[i].x,
                    that.bubblesValue[i].y,
                    that.drag,
                    that.bubblesValue[i].name,
                    that.bubblesValue[i].activity_id,
                    that.bubblesValue[i].purpose,
                    that.bubblesValue[i].parent_id,
                    that.bubblesValue[i].parent_name);

                that.save_image = true;
            }
        }

    }


    draw_bubble(id, x, y, drag, name, activity_id, purpose, parent_id, parent_name) {
        this.bubbles_new[id] = new Bubble(
            this.myCanvas,
            x, y,
            name, id,
            activity_id,
            purpose,
            (parent_id !== this.idValue),
            parent_name,
            this)
    }
}
