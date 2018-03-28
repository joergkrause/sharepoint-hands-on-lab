$server = "http://ec2-18-194-237-57.eu-central-1.compute.amazonaws.com"
$site = "$server:33333"
# ??
$cssFile = "assets/campmaster.css"
$web = Get-SPWeb $site
$lib = $web.GetFolder("SiteAssets")
$files = $lib.Files
$file = Get-ChildItem $cssFile
$files.Add("SiteAssets/campmaster.css", $file.OpenRead(), $false)
# Manchmal erst mit Update in der Datenbank
#$files.Update()
# Wichtig: Verbindung beenden
$web.Dispose()
