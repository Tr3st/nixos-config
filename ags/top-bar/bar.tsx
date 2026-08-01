import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { LeftModules } from "./left-module"
import { DynamicIsland } from "./dynamic-island"
import { RightModules } from "./right-module"

export function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        className="main-bar"
        monitor={monitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
    >
        <centerbox className="bar-container">
            <LeftModules />
            <DynamicIsland />
            <RightModules />
        </centerbox>
    </window>
}
