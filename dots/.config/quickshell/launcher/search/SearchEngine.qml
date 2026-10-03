import QtQuick
import Quickshell.Io

Item {
    id: engine
    visible: false

    // === State ===
    property string activeMode: "search"
    property string calculation: ""
    readonly property alias resultModel: _resultModel
    readonly property bool clipboardLoaderRunning: clipboardLoader.running
    readonly property bool wallpaperLoaderRunning: wallpaperLoader.running

    // Derived
    readonly property bool isClipboardMode: activeMode === "clipboard"
    readonly property bool isWallpaperMode: activeMode === "wallpaper"
    readonly property bool isDualPane: isClipboardMode

    // Internal data
    property var _allResults: []
    property var _clipboardResults: []
    property var _wallpaperResults: []
    property string _lastQuery: ""

    ListModel { id: _resultModel }

    // === Data loaders ===

    Process {
        id: loader
        command: ["sh", "-lc", "$HOME/.config/quickshell/scripts/launcher/spotlight-items"]
        running: true
        stdout: StdioCollector { id: loaderOutput }
        onExited: {
            try {
                engine._allResults = JSON.parse(loaderOutput.text)
                engine.rebuild(engine._lastQuery)
            } catch (error) {
                console.log("spotlight data parse failed", error)
            }
        }
    }

    Process {
        id: clipboardLoader
        command: ["sh", "-lc", "$HOME/.config/quickshell/scripts/clipboard/clipboard-items"]
        stdout: StdioCollector { id: clipboardOutput }
        onExited: {
            try {
                engine._clipboardResults = JSON.parse(clipboardOutput.text)
                engine.rebuild(engine._lastQuery)
            } catch (error) {
                console.log("spotlight clipboard parse failed", error)
            }
        }
    }

    Process {
        id: wallpaperLoader
        command: ["sh", "-lc", "$HOME/.config/quickshell/scripts/wallpaper/wallpaper-items"]
        running: true
        stdout: StdioCollector { id: wallpaperOutput }
        onExited: {
            try {
                engine._wallpaperResults = JSON.parse(wallpaperOutput.text)
                engine.rebuild(engine._lastQuery)
            } catch (error) {
                console.log("spotlight wallpaper parse failed", error)
            }
        }
    }

    Process {
        id: calculator
        stdout: StdioCollector { id: calculatorOutput }
        onExited: engine.calculation = calculatorOutput.text.trim()
    }

    // === Public API ===

    function startClipboardLoader() {
        if (!clipboardLoader.running) clipboardLoader.running = true
    }

    function startWallpaperLoader() {
        if (!wallpaperLoader.running) wallpaperLoader.running = true
    }

    function rebuild(query) {
        _lastQuery = query
        const trimmed = query.trim()
        const prefix = trimmed.length > 0 ? trimmed.charAt(0) : ""

        // Auto-detect mode from prefix
        if (prefix === ":") {
            activeMode = "clipboard"
            if (!clipboardLoader.running && _clipboardResults.length === 0)
                clipboardLoader.running = true
        } else if (prefix === "@") {
            activeMode = "wallpaper"
            if (!wallpaperLoader.running && _wallpaperResults.length === 0)
                wallpaperLoader.running = true
        } else if (prefix === ">") {
            activeMode = "commands"
        } else if (activeMode === "clipboard" || activeMode === "wallpaper" || activeMode === "commands") {
            if (prefix !== ":" && prefix !== "@" && prefix !== ">") {
                activeMode = "search"
            }
        }

        // Filter
        const normalized = (prefix === ":" || prefix === ">" || prefix === "@"
            ? trimmed.slice(1) : trimmed).toLowerCase()
        let source = _allResults
        if (activeMode === "clipboard") source = _clipboardResults
        else if (activeMode === "wallpaper") source = _wallpaperResults

        _resultModel.clear()

        // Shell run entry
        if (prefix !== ":" && prefix !== "@" && trimmed.length > 0
                && activeMode !== "wallpaper" && activeMode !== "clipboard") {
            _resultModel.append({
                id: "__run__", name: trimmed, subtitle: "Run shell command",
                kind: "run", isImage: false, preview: "", icon: "",
                mime: "", label: trimmed
            })
        }

        for (let i = 0; i < source.length; i++) {
            const item = source[i]
            const kind = String(item.kind || (activeMode === "wallpaper" ? "wallpaper" : "app"))

            if (activeMode === "apps" && kind !== "app") continue
            if (activeMode === "files" && kind !== "file") continue
            if (activeMode === "commands" && kind !== "command") continue

            const haystack = ((item.name || "") + " " + (item.subtitle || "")
                + " " + (item.label || "")).toLowerCase()
            if (normalized === "" || haystack.indexOf(normalized) !== -1) {
                _resultModel.append({
                    id: String(item.id || item.path || ""),
                    name: String(item.name || ""),
                    subtitle: String(item.subtitle || item.label
                        || (activeMode === "wallpaper"
                            ? ("Wallpaper \u2022 " + (item.filename || "")) : "")),
                    kind: kind,
                    mime: String(item.mime
                        || (activeMode === "wallpaper" ? "image/jpeg" : "")),
                    label: String(item.label || item.name || ""),
                    isImage: Boolean(item.isImage || activeMode === "wallpaper"),
                    preview: String(item.preview || item.path || ""),
                    icon: String(item.icon || "")
                })
            }
            if (_resultModel.count >= 60) break
        }

        updateCalculation(trimmed)
        return _resultModel.count > 0 ? 0 : -1
    }

    function updateCalculation(query) {
        const expression = query.replace(/^[:>@]/, "").trim()
        if (/^[0-9+*/%().,\- ]+$/.test(expression) && /[0-9]/.test(expression)) {
            calculator.command = ["qalc", "-t", expression]
            calculator.running = true
        } else {
            calculation = ""
        }
    }
}
