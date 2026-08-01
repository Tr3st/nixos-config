import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import Hyprland from "gi://AstalHyprland"
import { Variable, GLib } from "astal"

// Clock variable (Data e Ora)
const time = Variable("").poll(1000, () => 
    GLib.DateTime.new_now_local().format("%a %d %b | %H:%M")!
)

export function LeftModules() {
    const hypr = Hyprland.get_default()

    return <box className="left-modules" spacing={8}>
        {/* Logo NixOS */}
        <button 
            className="module-box nix-logo"
            onClicked={() => {
                // In seguito collegheremo l'apertura del launcher completo
                print("Apri Menu / Launcher")
            }}
        >
            <label label=" " />
        </button>

        {/* Data e Ora */}
        <box className="module-box clock">
            <label label={time()} />
        </box>

        {/* Workspaces Hyprland */}
        <box className="module-box workspaces" spacing={4}>
            {/* Generati dinamicamente da Hyprland */}
        </box>
    </box>
}
