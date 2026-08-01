import { App } from "astal/gtk3"
import { Bar } from "./top-bar/bar"

App.start({
    css: "./style.css",
    main() {
        App.get_monitors().map(Bar)
    },
})
