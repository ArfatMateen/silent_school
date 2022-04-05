# Rename Items in given folder with the names given in a text file.

$video_names = Get-Content -Path @("C:\Folder which contain names file\Names file.txt")
$new_names = @()

for ($num = 0; $num -lt $video_names.Count; $num++)
{
    $new_names += '{0} - {1}.mp4' -f $num, $video_names[$num].Trim()
}


$files = Get-ChildItem -Path "C:\Folder which contain files to be renamed" -Filter *.mp4 | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20) }) }

if($files.count -eq $new_names.count)
{
    for ($i = 0; $i -lt $array.Count; $i++)
    {
        Rename-Item -Path $files[$i].FullName -NewName $new_names[$i]
    }
}
else
{
   Write-Host "Counts are not identical!" -ForegroundColor Red -BackgroundColor Black
}
