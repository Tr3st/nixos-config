import { App, Astal, Gtk, Gdk } from "astal/gtk3"
import { Variable, GLib } from "astal"

const time = Variable("").poll(1000, () => 
    GLib.DateTime.new_now_local().format("%a %d %b | %H:%M")!
)

export function LeftModules() {
    return <box spacing={4} valign={Gtk.Align.CENTER}>
        
        {/* Logo NixOS */}
        <button className="module-box nix-logo" onClicked={() => print("Launcher")}>
            <label label=" " />
        </button>

        {/* Data e Ora */}
        <box className="module-box clock">
            <label label={time()} />
        </box>

        {/* Workspaces FINTI per testare il Notch */}
        <box className="module-box workspaces" valign={Gtk.Align.CENTER}>
            <box spacing={6} valign={Gtk.Align.CENTER}>
                <button className="workspace-btn active" />
                <button className="workspace-btn" />
                <button className="workspace-btn" />
                <button className="workspace-btn" />
            </box>
        </box>
        
    </box>
}
