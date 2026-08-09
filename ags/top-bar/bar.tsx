import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { LeftModules } from "./left-module"
import { DynamicIsland } from "./dynamic-island"
import { RightModules } from "./right-module"

// Questo componente disegna la curva inversa
function NotchCorner({ right = false }) {
    return <box 
        className={`corner ${right ? "right" : "left"}`} 
        valign={Gtk.Align.START} 
    />
}

export function Bar(monitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor
    const { EXCLUSIVE } = Astal.Exclusivity

    return <window
        className="main-bar"
        monitor={monitor}
        exclusivity={EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
    >
        {/* L'intero blocco DEVE stare in alto */}
        <centerbox className="bar-container" valign={Gtk.Align.START}>
            
            {/* GRUPPO SINISTRA: spacing 0 è obbligatorio per la fluidità */}
            <box halign={Gtk.Align.START} valign={Gtk.Align.START} spacing={0}>
                <box className="notch-content">
                    <LeftModules />
                </box>
                <NotchCorner right />
            </box>

            {/* GRUPPO CENTRO (DYNAMIC ISLAND) */}
            <box halign={Gtk.Align.CENTER} valign={Gtk.Align.START} spacing={0}>
                <NotchCorner />
                <box className="notch-content">
                    <DynamicIsland />
                </box>
                <NotchCorner right />
            </box>

            {/* GRUPPO DESTRA */}
            <box halign={Gtk.Align.END} valign={Gtk.Align.START} spacing={0}>
                <NotchCorner />
                <box className="notch-content">
                    <RightModules />
                </box>
            </box>

        </centerbox>
    </window>
}
