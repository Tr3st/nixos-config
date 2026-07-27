// ==========================================
// AGS - CORE ARCHITECTURE (GRUVBOX)
// ==========================================

// Import espliciti (Risolve il ReferenceError)
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

// --- MODULO SINISTRO: Workspaces ---
const Workspaces = () => Widget.Box({
    class_name: 'pill workspaces',
    children: Array.from({ length: 5 }, (_, i) => i + 1).map(i => Widget.Button({
        attribute: i,
        label: `${i}`,
        on_clicked: () => Hyprland.messageAsync(`dispatch workspace ${i}`),
    })),
});

// --- MODULO CENTRALE: Orologio ---
const Clock = () => Widget.Label({
    class_name: 'pill clock',
    setup: self => self.poll(1000, self => {
        self.label = new Date().toLocaleTimeString('it-IT', { hour: '2-digit', minute: '2-digit' });
    }),
});

// --- MODULO DESTRO: Audio ---
const Volume = () => Widget.Box({
    class_name: 'pill volume',
    children: [
        Widget.Icon().hook(Audio.speaker, self => {
            const isMuted = Audio.speaker.stream?.is_muted;
            self.icon = isMuted ? 'audio-volume-muted-symbolic' : 'audio-volume-high-symbolic';
        }),
        Widget.Label().hook(Audio.speaker, self => {
            const vol = Math.round((Audio.speaker.volume || 0) * 100);
            self.label = ` ${vol}%`;
        }),
    ],
});

// 2. Assembliamo la Barra
const Bar = (monitor = 0) => Widget.Window({
    monitor,
    name: `bar${monitor}`,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: Widget.CenterBox({
        class_name: 'bar-container',
        start_widget: Widget.Box({
            hpack: 'start',
            child: Workspaces(),
        }),
        center_widget: Widget.Box({
            hpack: 'center',
            child: Clock(),
        }),
        end_widget: Widget.Box({
            hpack: 'end',
            child: Volume(),
        }),
    }),
});

// 3. Esportiamo la configurazione ad AGS
App.config({
    style: App.configDir + '/style.css', // Usa il percorso assoluto dinamico per sicurezza
    windows: [Bar()],
});
