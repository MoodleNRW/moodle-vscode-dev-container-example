# Moodle VSCode Dev Container Example

## Installation unter Windows

### 1. WSL2 installieren
https://learn.microsoft.com/de-de/windows/wsl/install
* In der Regel genügt es, den Befehl `wsl --install` in einem Windows Terminal mit Admin-Rechten auszuführen.
* Windows muss ggfs. neu gestartet werden.

### 2.a Docker Desktop für Windows installieren
https://www.docker.com/
* Beim Installieren darauf achten, dass das Häkchen ✔️ bei *Use WSL 2 instead of Hyper-V (recommended)* gesetzt ist.
* Anschließend Docker starten. Sobald das Rechteck unten links grün wird (beim Darüberfahren mit der Maus erscheint der Tooltip *Engine running*),
kann das Fenster geschlossen werden ❌
* ❗ Wichtig: Docker sollte weiterhin im Systemtray laufen (unten rechts in der Taskbar) ❗

### 2.b Docker Desktop für Mac installieren
https://www.docker.com/
* Beim Download darauf achten, dass die richtige Chip-Variante ausgewählt wird (Intel Chip amd-64 vs Apple Chip arm-64).
* Herrausfindbar ist dies über das Apple-Menü () -> "Über diesen Mac" -> Chip / Prozessor Bezeichnung.
* Anschließend Docker starten. Sobald das Rechteck unten links grün wird (beim Darüberfahren mit der Maus erscheint der Tooltip *Engine running*),
kann das Fenster geschlossen werden ❌
* ❗ Wichtig: Docker sollte weiterhin laufen und der Prozess sollte nicht manuell beendet werden ❗

### 3. Visual Studio Code installieren
https://code.visualstudio.com/
* Beim Starten von VS Code sollte Docker auf dem System erkannt werden und das Installieren der empfohlenen Erweiterung vorgeschlagen werden:
Dev Containers von Microsoft (`ms-vscode-remote.remote-containers`). Diese Erweiterung installieren.

### 4. Container starten
* In VS Code über *Datei &rarr; Ordner öffnen...* zu dem Verzeichnis navigieren, in dem sich der Ordner *moodle-dev-container-master-2* befindet, und diesen öffnen
* VS Code sollte erkennen, dass das Verzeichnis eine *Dev Container*-Konfigurationsdatei enthält, und vorschlagen, den Ordner zum Entwickeln in einem Container zu öffnen.
* Auf *Reopen in Container* klicken.
* Beim erstmaligen Öffnen wird nun Moodle installiert. Das kann einige Zeit in Anspruch nehmen 🕒

Anschließend sollte Moodle über `localhost:8080/moodle-400` erreichbar sein.
