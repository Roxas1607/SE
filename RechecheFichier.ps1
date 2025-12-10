# Demande du chemin où chercher
$chemin = Read-Host "Chemin où effectuer la recherche (ex: C:\Users\Marion\Documents)"

# Demande du nom du fichier à rechercher
$recherche = Read-Host "Nom du fichier à rechercher"

# Recherche du fichier
$resultats = Get-ChildItem -Path $chemin -Recurse -Filter "$recherche" -ErrorAction SilentlyContinue

# Vérification
if ($resultats) {
    Write-Host "Fichier trouvé !" -ForegroundColor Green

    # Chemin complet du premier résultat
    $new_chemin = $resultats[0].FullName

    Write-Host "Chemin du fichier :" $new_chemin
}
else {
    Write-Host "Fichier non trouvé." -ForegroundColor Yellow
}
