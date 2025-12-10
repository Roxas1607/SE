# Demande du chemin où chercher
$chemin = Read-Host "Chemin où effectuer la recherche"

if (-not (Test-Path $chemin)) {
    Write-Host "Le chemin n'existe pas." -ForegroundColor Red
    exit
}

# Nom du fichier (partiel accepté)
$recherche = Read-Host "Nom du fichier (partiel accepté)"

# Recherche partielle + tri par date
$resultats = Get-ChildItem -Path $chemin -Recurse -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -like "*$recherche*" } |
    Sort-Object -Property LastWriteTime -Descending

if (-not $resultats) {
    Write-Host "Aucun fichier trouvé." -ForegroundColor Yellow
    exit
}

# Affichage numéroté
Write-Host "`nRésultats trouvés (récent → ancien) : $($resultats.Count)`n"

$i = 1
foreach ($f in $resultats) {
    $date = $f.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
    Write-Host "$i : [$date] $($f.FullName)"
    $i++
}

# Sélection multiple
$choix = Read-Host "`nEntrez les numéros des fichiers à télécharger (ex: 1,3,5,10)"

# Nettoyage + conversion en liste de chiffres
$nums = $choix -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -as [int] }

# Validation
foreach ($n in $nums) {
    if ($n -lt 1 -or $n -gt $resultats.Count) {
        Write-Host "Numéro invalide : $n" -ForegroundColor Red
        exit
    }
}

# Dossier destination
$destination = Read-Host "`nDossier où copier les fichiers"
if (-not (Test-Path $destination)) {
    Write-Host "Le dossier n'existe pas." -ForegroundColor Red
    exit
}

# Copie des fichiers sélectionnés
Write-Host "`nTéléchargement en cours..." -ForegroundColor Cyan

foreach ($n in $nums) {
    $src = $resultats[$n - 1].FullName
    try {
        Copy-Item -Path $src -Destination $destination -Force
        Write-Host "✔ Copié : $src"
    }
    catch {
        Write-Host "❌ Erreur pour : $src" -ForegroundColor Red
    }
}

Write-Host "`nTéléchargement terminé !" -ForegroundColor Green
Write-Host "Fichiers copiés vers : $destination"
