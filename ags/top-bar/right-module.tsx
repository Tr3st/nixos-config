import { App, Astal, Gtk } from "astal/gtk3"

export function RightModules() {
    return <box className="right-modules" spacing={4} halign={Gtk.Align.END}>
        {/* Meteo */}
        <box className="module-box weather">
            <label label="🌤️ --°C" />
        </box>

        {/* Volume */}
        <button className="module-box volume" onClicked={() => print("Pop-up Volume")}>
            <label label="🔊 80%" />
        </button>

        {/* Network & Bluetooth */}
        <button className="module-box network-bt" onClicked={() => print("Pop-up Network")}>
            <label label="󰤨  󰂯" />
        </button>

        {/* Batteria (rilevata da AGS) */}
        <box className="module-box battery">
            <label label="󰁹 100%" />
        </box>

        {/* Spegnimento */}
        <button className="module-box power" onClicked={() => print("Pop-up Power")}>
            <label label="" />
        </button>
    </box>
}
