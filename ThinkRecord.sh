#!/bin/bash

# Descriere: Acest script permite captura video și audio a ecranului, salvând rezultatele într-un director specificat.

# Instrucțiuni de utilizare:
#   1. Asigurați-vă că aveți instalate dependențele necesare: wf-recorder, ffmpeg și slurp.
#   2. Modificați calea directorului de ieșire (output_directory) după preferințele dvs.
#   3. Rulați scriptul într-un terminal.
#   4. Apare o fereastră care vă permite să selectați zona ecranului de capturat.
#   5. Captura video și audio vor începe automat.
#   6. Apăsați Ctrl+C în terminal pentru a opri înregistrarea.

# Directorul în care se vor salva înregistrările
output_directory="/home/thinkroot99/"

# Funcție pentru instalarea dependențelor
function install_dependencies() {
    echo "Installing dependencies..."

    # Verifică și instalează wf-recorder
    if ! command -v wf-recorder &> /dev/null; then
        echo "Installing wf-recorder..."
        sudo apt-get install wf-recorder -y
    fi

    # Verifică și instalează ffmpeg
    if ! command -v ffmpeg &> /dev/null; then
        echo "Installing ffmpeg..."
        sudo apt-get install ffmpeg -y
    fi

    echo "Dependencies installed."
}

# Funcție pentru oprirea controlată a scriptului și a proceselor copil
function stop_script() {
    echo "Stopping..."
    pkill -P $$
    exit
}

# Verifică și instalează dependențele dacă nu sunt instalate
install_dependencies

# Configurează trap-ul pentru semnalul SIGINT (Ctrl+C) pentru oprirea scriptului și proceselor copil
trap stop_script SIGINT

# Crează directorul pentru înregistrări dacă nu există
mkdir -p "$output_directory"

# Capturează regiunea ecranului folosind slurp și wf-recorder
wf-recorder -g "$(slurp)" -f "$output_directory/video_output.mp4" &

# Capturează sunetul de la microfon folosind arecord
audio_file="$output_directory/output.wav"
arecord -d 5 -f cd "$audio_file" &

echo "Recording video and audio. Press CTRL+C to stop."

# Așteaptă înregistrarea video și audio
wait

echo "Done!"
