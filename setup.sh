#!/bin/bash

# Dieses Skript automatisiert die Einrichtung des RVC-Projekts.

echo "Schritt 1: Klone das RVC-Repository..."
git clone https://github.com/fumiama/Retrieval-based-Voice-Conversion-WebUI.git
if [ $? -ne 0 ]; then
    echo "Fehler beim Klonen des Repositories. Breche ab."
    exit 1
fi
echo "Repository erfolgreich geklont."

echo "Schritt 2: Wende den Patch für die AMD-GPU-Erkennung an..."
# Wechsle in das neue Verzeichnis
cd Retrieval-based-Voice-Conversion-WebUI

# Erstelle eine Patch-Datei
cat > web.py.patch << 'EOF'
--- a/web.py
+++ b/web.py
@@ -84,47 +84,20 @@
 mem = []
 if_gpu_ok = False

-if torch.cuda.is_available() or ngpu != 0:
+if torch.cuda.is_available():
+    if_gpu_ok = True
     for i in range(ngpu):
         gpu_name = torch.cuda.get_device_name(i)
-        if any(
-            value in gpu_name.upper()
-            for value in [
-                "10",
-                "16",
-                "20",
-                "30",
-                "40",
-                "A2",
-                "A3",
-                "A4",
-                "P4",
-                "A50",
-                "500",
-                "A60",
-                "70",
-                "80",
-                "90",
-                "M4",
-                "T4",
-                "TITAN",
-                "4060",
-                "L",
-                "6000",
-            ]
-        ):
-            # A10#A100#V100#A40#P40#M40#K80#A4500
-            if_gpu_ok = True  # 至少有一张能用的N卡
-            gpu_infos.append("%s\t%s" % (i, gpu_name))
-            mem.append(
-                int(
-                    torch.cuda.get_device_properties(i).total_memory
-                    / 1024
-                    / 1024
-                    / 1024
-                    + 0.4
-                )
+        gpu_infos.append("%s\t%s" % (i, gpu_name))
+        mem.append(
+            int(
+                torch.cuda.get_device_properties(i).total_memory
+                / 1024
+                / 1024
+                / 1024
+                + 0.4
             )
+        )
 if if_gpu_ok and len(gpu_infos) > 0:
     gpu_info = "\n".join(gpu_infos)
     default_batch_size = min(mem) // 2
EOF

# Wende den Patch an
patch < web.py.patch
if [ $? -ne 0 ]; then
    echo "Fehler beim Anwenden des Patches auf web.py. Breche ab."
    rm web.py.patch
    exit 1
fi
echo "Patch erfolgreich angewendet."

# Lösche die Patch-Datei
rm web.py.patch

echo "Schritt 3: Erstelle das 'audio_input'-Verzeichnis..."
mkdir -p audio_input
echo "'audio_input'-Verzeichnis erstellt."

echo ""
echo "Setup abgeschlossen!"
echo "Bitte kopieren Sie Ihre 'stimme.mp3'-Datei jetzt in das 'Retrieval-based-Voice-Conversion-WebUI/audio_input'-Verzeichnis."
echo "Folgen Sie danach den Anweisungen in der ANLEITUNG.md."

exit 0
