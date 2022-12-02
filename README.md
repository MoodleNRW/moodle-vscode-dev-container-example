# Moodle VSCode Dev Container Example

## Installation Docker

<table>
  <thead>
    <tr>
      <th>Windows</th>
      <th>macOS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>1. WSL2 installieren</strong><br>https://learn.microsoft.com/de-de/windows/wsl/install
<ul><li>In der Regel genügt es, den Befehl `wsl --install` in einem Windows Terminal mit Admin-Rechten auszuführen.</li>
  <li>Windows muss ggfs. neu gestartet werden.</li></ul>
</td>
      <td><strong>Variante 1: Docker Desktop für Mac mit brew installieren</strong><br>Ein elleganteter Weg zur Installation ist mit <a href="http://brew.sh">Homebrew</a> und <a href="http://caskroom.io/">Homebrew Cask</a>.
        <div class="highlight highlight-source-shell" dir="auto"><pre>brew install --cask docker     # Installiert Docker <br>open /Applications/Docker.app  # Startet Docker</pre></div></td>
    </tr>
    <tr>
      <td>  <strong>2. Docker Desktop für Windows installieren</strong><br>
  https://www.docker.com/
<ul><li>Beim Installieren darauf achten, dass das Häkchen ✔️ bei *Use WSL 2 instead of Hyper-V (recommended)* gesetzt ist.</li>
<li>Anschließend Docker starten. Sobald das Rechteck unten links grün wird (beim Darüberfahren mit der Maus erscheint der Tooltip *Engine running*),
  kann das Fenster geschlossen werden ❌</li>
 <li>❗ Wichtig: Docker sollte weiterhin im Systemtray laufen (unten rechts in der Taskbar) ❗</li></ul></td>
      <td><strong>Variante 2: Docker Desktop über Download installieren</strong><br>Alternativ kann Docker auch direkt unter https://www.docker.com/ heruntergeladen werden.<br>
      <ul><li>Beim Download darauf achten, dass die richtige Chip-Variante ausgewählt wird (Intel Chip amd-64 vs Apple Chip arm-64).</li>
        <li>Herrausfindbar ist dies über das Apple-Menü () -> "Über diesen Mac" -> Chip / Prozessor Bezeichnung.</li>
        <li>Anschließend Docker starten. Sobald das Rechteck unten links grün wird (beim Darüberfahren mit der Maus erscheint der Tooltip *Engine running*), kann das Fenster geschlossen werden ❌</li>
<li> ❗ Wichtig: Docker sollte weiterhin laufen und der Prozess sollte nicht manuell beendet werden ❗</li></td>
    </tr>
  </tbody>
</table>



## Installation VSCode und Inbetriebnahme

### 1. Visual Studio Code installieren

<table>
  <thead>
    <tr>
      <th>Windows</th>
      <th>macOS</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Download unter <href="https://code.visualstudio.com/">https://code.visualstudio.com/</a><br>
<ul><li> Beim Starten von VS Code sollte Docker auf dem System erkannt werden und das Installieren der empfohlenen Erweiterungen vorgeschlagen werden:
Dev Containers von Microsoft (`ms-vscode-remote.remote-containers`) und - im Falle von Windows - WSL von Microsoft (`ms-vscode-remote.remote-wsl`). Diese Erweiterungen installieren.)</li></td>
      <td>Installation mit <a href="http://brew.sh">Homebrew</a> und <a href="http://caskroom.io/">Homebrew Cask</a>.
        <div class="highlight highlight-source-shell" dir="auto"><pre>brew install --cask visual-studio-code</pre></div>
        Alternativ kann Visual Studio Code auch direkt unter https://code.visualstudio.com/ heruntergeladen werden. </td>
    </tr>
    <tr>
      <td><strong>Empfehlung für Windows</strong><br>Da PHP-Anwendungen in Docker unter Windows Performanceprobleme haben können (wie es bei Moodle leider der Fall ist) empfiehlt es sich, den Devcontainer direkt aus der WSL heraus zu bedienen. Dazu mit der WSL Extension in VSCode in die WSL verbinden (über die Schaltfläche unten links) und das Verzeichnis direkt in die WSL clonen.</td>
      <td><strong>Empfehlung für macOS</strong><br>Um die Performance von Docker unter macOS maßgeblich zu verbessern sollte der VirtioFS Treiber aktiviert sein. Dieser findet sich in Docker Desktop unter <i>Settings -> Beta features -> Enable VirtioFS accelerated directory sharing</i>.</td>
    </tr>
  </tbody>
</table>

### 2. Container starten
* In VS Code über *Datei &rarr; Ordner öffnen...* zu dem Verzeichnis navigieren, in dem sich der geclonte Ordner (Default *moodle-vscode-dev-container-example*) befindet, und diesen öffnen
* VS Code sollte erkennen, dass das Verzeichnis eine *Dev Container*-Konfigurationsdatei enthält, und vorschlagen, den Ordner zum Entwickeln in einem Container zu öffnen.
* Auf *Reopen in Container* klicken.
* Beim erstmaligen Öffnen wird nun Moodle installiert. Das kann einige Zeit in Anspruch nehmen 🕒

Anschließend sollte Moodle über `localhost:8080/moodle-400` erreichbar sein.
