#!/bin/bash

# Guardar el número de actualizaciones de pacman (repositorios oficiales)
PACMAN_UPDATES=$(checkupdates 2> /dev/null | wc -l)

# Guardar el número de actualizaciones de AUR
AUR_UPDATES=$(yay -Qu 2> /dev/null | wc -l)

# Sumar ambos resultados
TOTAL_UPDATES=$((PACMAN_UPDATES + AUR_UPDATES))

# Mostrar el resultado
echo "$TOTAL_UPDATES"

