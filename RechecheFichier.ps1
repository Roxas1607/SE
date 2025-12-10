# Demande du chemin où chercher
$chemin = Read-Host "Chemin où effectuer la recherche"

# Vérifie si le chemin existe
if (-not (Test-Path $chemin)) {
    Write-Host "Le chemin n'existe pas." -ForegroundColor Red
    exit
}

# Demande du nom du fichier (recherche partielle)
$recherche = Read-Host "Nom du fichier (partiel accepté)"

# Recherche partielle
$resultats = Get-ChildItem -Path $chemin -Recurse -ErrorAction SilentlyContinue |
             Where-Object { $_.Name -like "*$recherche*" }

# Affichage des chemins uniquement
if ($resultats) {
    foreach ($f in $resultats) {
        Write-Host $f.FullName
    }
}
else {
    Write-Host "Aucun fichier trouvé." -ForegroundColor Yellow
}
