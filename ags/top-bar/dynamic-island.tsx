import { App, Astal, Gtk } from "astal/gtk3"
import { Variable } from "astal"

// Stato per l'espansione della Dynamic Island
const isExpanded = Variable(false)

export function DynamicIsland() {
    return <box className="dynamic-island-container">
        <button 
            className="module-box dynamic-island"
            onClicked={() => isExpanded.set(!isExpanded.get())}
        >
            <box spacing={8}>
                <label label="󰀦" /> {/* Icona dinamica (App/Media) */}
                <label label="Desktop" /> {/* Titolo dinamico */}
            </box>
        </button>
    </box>
}
