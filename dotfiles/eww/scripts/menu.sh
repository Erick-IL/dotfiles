#!/bin/bash

names=(
  "FireFox"
  "InteliJ IDEA"
  "Discord"
  "Spotify"
  "Arduino IDE"
  "PyCharm"
  "Rider"
  "Obsidian"
  "Steam"
  "Postman"
  "Sober"
  
)

execs=(
  "firefox"
  "flatpak run com.jetbrains.IntelliJ-IDEA-Ultimate"
  "flatpak run com.discordapp.Discord"
  "flatpak run com.spotify.Client"
  "flatpak run cc.arduino.IDE2"
  "flatpak run com.jetbrains.PyCharm-Professional"
  "flatpak run com.jetbrains.Rider"
  "flatpak run md.obsidian.Obsidian"
  "flatpak run com.valvesoftware.Steam"
  "flatpak run com.getpostman.Postman"
  "flatpak run org.vinegarhq.Sober"
  
)

icons=(
  "/usr/share/icons/hicolor/scalable/apps/firefox.svg"
  "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/com.jetbrains.IntelliJ-IDEA-Ultimate.svg"
  "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/com.discordapp.Discord.svg"
  "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/com.spotify.Client.svg"
  "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/cc.arduino.IDE2.svg"
  "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/com.jetbrains.PyCharm-Professional.svg"
  "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/com.jetbrains.Rider.svg"
  "/var/lib/flatpak/exports/share/icons/hicolor/512x512/apps/md.obsidian.Obsidian.png"
  "/var/lib/flatpak/exports/share/icons/hicolor/256x256/apps/com.valvesoftware.Steam.png"
  "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/com.getpostman.Postman.svg"
  "/var/lib/flatpak/exports/share/icons/hicolor/scalable/apps/org.vinegarhq.Sober.svg"
)

terminal=(
  false
  true
  false
  false
  true
  false
  false
  false
)

json="["

for i in "${!names[@]}"; do
  [[ $i -ne 0 ]] && json+=","
  json+="{\"name\":\"${names[$i]}\",\"exec\":\"${execs[$i]}\",\"icon\":\"${icons[$i]}\",\"terminal\":\"${terminal[$i]}\"}"
done

json+="]"
echo "$json"