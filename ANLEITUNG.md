# Anleitung zum Trainieren des RVC-Stimmmodells auf CachyOS (Arch Linux) mit AMD-GPU

Diese Anleitung führt Sie durch den gesamten Prozess, um das RVC-Modell mit Ihrer eigenen Stimmprobe auf Ihrem CachyOS-System zu trainieren.

---

### Schritt 1: Automatisches Setup ausführen

1.  **Öffnen Sie ein Terminal in dem Verzeichnis, in dem sich diese `ANLEITUNG.md`-Datei befindet.**

2.  **Machen Sie das Setup-Skript ausführbar:**
    ```bash
    chmod +x setup.sh
    ```

3.  **Führen Sie das Setup-Skript aus:**
    ```bash
    ./setup.sh
    ```
    Das Skript wird das originale RVC-Projekt klonen, die notwendige Änderung für Ihre AMD-GPU anwenden und den `audio_input`-Ordner erstellen.

4.  **Kopieren Sie Ihre Stimmprobe:**
    Verschieben Sie Ihre `stimme.mp3`-Datei in den neu erstellten Ordner: `Retrieval-based-Voice-Conversion-WebUI/audio_input/`.

---

### Schritt 2: Systemabhängigkeiten und ROCm-Treiber installieren

Führen Sie die folgenden Befehle im Terminal aus, um die Treiber für Ihre AMD-GPU zu installieren.

```bash
# ROCm-Treiber und HIP/OpenCL SDK installieren
sudo pacman -S --noconfirm rocm-hip-sdk rocm-opencl-sdk

# Fügen Sie Ihren Benutzer zu den 'render' und 'video' Gruppen hinzu
sudo usermod -aG render $USER
sudo usermod -aG video $USER
```
**WICHTIG:** Starten Sie nach diesem Schritt Ihren Computer neu, damit die Gruppenänderungen wirksam werden.

---

### Schritt 3: Python-Umgebung und Abhängigkeiten einrichten

1.  **Wechseln Sie in das neue Verzeichnis:**
    ```bash
    cd Retrieval-based-Voice-Conversion-WebUI
    ```

2.  **Erstellen Sie eine virtuelle Python-Umgebung (empfohlen):**
    ```bash
    python -m venv venv
    source venv/bin/activate
    ```

3.  **Installieren Sie die korrekte PyTorch-Version für ROCm:**
    ```bash
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.2
    ```

4.  **Installieren Sie die restlichen Python-Pakete:**
    ```bash
    pip install -r requirements/amd.txt
    ```

---

### Schritt 4: Vorab trainierte Modelle herunterladen

Führen Sie das Download-Skript aus, um die Basismodelle für RVC herunterzuladen.

```bash
python infer/lib/rvcmd.py download all
```
Dieser Vorgang kann eine Weile dauern.

---

### Schritt 5: Das Training starten

Jetzt ist alles bereit.

1.  **Starten Sie die WebUI:**
    ```bash
    python web.py
    ```

2.  **Öffnen Sie die Web-Oberfläche** in Ihrem Browser (normalerweise `http://127.0.0.1:7865`).

3.  Folgen Sie den Anweisungen in der WebUI im **"Train"**-Tab, um Ihr Modell zu trainieren:
    *   **Experiment name:** `KumpelStimme`
    *   **Training folder path:** `./audio_input`
    *   ...und die anderen empfohlenen Einstellungen (48k, v2, pitch guidance).
    *   Klicken Sie nacheinander auf **Process data**, **Feature extraction**, **Train model** und **Train feature index**.

Viel Spaß!
