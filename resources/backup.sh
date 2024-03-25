#!/bin/ash

# Spécifiez le répertoire que vous souhaitez traiter
backup_path="/volumes/share/Backup"

# Déterminez la date actuelle
current_date=$(date +%s)

# Déterminez la limite de date (une semaine en secondes)
limit_date=$((current_date - 7 * 24 * 60 * 60))

# Parcourez tous les fichiers dans le répertoire
for fichier in "$backup_path"/*; do
    # Vérifiez si le fichier est un fichier ordinaire
    if [ -f "$fichier" ]; then
        # Récupérez la date de modification du fichier en secondes depuis l'époque
        file_age=$(date -r "$fichier" +%s)

        # Vérifiez si la date de modification est antérieure à la limite
        if [ "$file_age" -lt "$limit_date" ]; then
            # Supprimez le fichier
            rm "$fichier"
        fi
    fi
done

# Déterminez tous les dossiers à sauvegarder
service=$(ls /volumes | grep "volume" | cut -d '_' -f 1)

volumes_path=''

# Stockez les chemins dans un variable
for path in $service
do
	volumes_path="/volumes/"$path"_volume "$volumes_path
done

# Ajoutez les cas particuliers
volumes_path="$volumes_path /volumes/certificates /root/.wg-easy"

# Créez l'archive
tar -czf $backup_path/$(date -I).tar.gz $volumes_path
chown root $backup_path/$(date -I).tar.gz
chgrp root $backup_path/$(date -I).tar.gz
chmod 400 $backup_path/$(date -I).tar.gz		

# tar --exclude='*.jpg' --exclude='*.png' --exclude='*.webp' -czvf /home/admin/jellyfin.tar.gz cache config transcodes

# tar --exclude='*.jpg' --exclude='*.png' --exclude='*.webp' --exclude='*[Mm]etadata*' --exclude='*[Mm]ediaCover*' --exclude='volumes/transmission_volume/config/resume/*' -czvf /Backup_volumes/$(date -I).tar.gz /volumes/*

