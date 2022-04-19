// We import the CSS which is extracted to its own file by esbuild.
// Remove this line if you add a your own CSS build pipeline (e.g postcss).
// import "../css/app.css"

// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

import {  TextEditor  } from './hooks/textEditHook'
// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"

let Hooks = {}

Hooks.TextEditor = TextEditor

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

description = document.getElementById("product-form_description")
window.addEventListener("js:set", e => {
        e.target.value = e.detail
    });

window.addEventListener(
    "phx:set-input-value",
    e => document.getElementById("product-form_description").setAttribute("value", e.detail.value)
)

window.addEventListener(
    "phx:set-indeterminate",
    e => {
        check = document.getElementById("check-all")
        val = e.detail.value
        console.log(val.active_ids)
        console.log(val.sketch_ids)
        console.log(val.checked_items)
        console.log(val.filter)

        if (
            (val.all_items == val.checked_items.length && !val.filter)
            || (val.active_ids.every(elem => val.checked_items.includes(elem)) && val.filter == true) 
            || (val.sketch_ids.every(elem => val.checked_items.includes(elem)) && val.filter == false)
        ) {
            check.indeterminate = false;
            check.checked = true;
        } else if (
            (val.checked_items.length > 0)
        ) {
            check.checked = false;
            check.indeterminate = true;
        } else {
            check.indeterminate = false;
            check.checked = false;
        }
    }
)

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

