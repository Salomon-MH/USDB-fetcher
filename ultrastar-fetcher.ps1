$allToFetch = Get-ChildItem .\toFetch\ -Filter "*.txt"

foreach ($songPath in $allToFetch) { 
	$songFull = Get-Content -Path $songPath.FullName -Encoding utf8;
	
	$songTitle = ($songFull | Select-String -Pattern "#TITLE:").toString().replace("#TITLE:","");
	$songArtist = ($songFull | Select-String -Pattern "#ARTIST:").toString().replace("#ARTIST:","");
	
	$musicString = $songFull | Select-String -Pattern "#MP3:";
	$musicFileName = $musicString.ToString().replace("#MP3:","");
	$videoFileName = $musicFileName.replace(".mp3", ".mp4");
	
	
	$videoString = $songFull | Select-String -Pattern "#VIDEO:";
	$videoStringNoPrefix = $videoString.ToString().replace("#VIDEO:","");
	$videoSplits = $videoStringNoPrefix.Split(",");
	
	try {
		$videoDownloadLink = ($videoSplits | Select-String -Pattern "v=").toString().replace("v=","");
	}
	catch {
		$videoDownloadLink = $null;
	}
	try {
		$songDownloadLink = ($videoSplits | Select-String -Pattern "a=").toString().replace("a=","");
	}
	catch {
		$songDownloadLink = $null;
	}
	if ($songDownloadLink -eq $null) {
		$songDownloadLink = $videoDownloadLink;
	}
	if ($videoDownloadLink -eq $null) {
		$videoDownloadLink = $songDownloadLink;
	}
	
	# Generate directory name
	$directoryname = "$($songArtist) - $($songTitle)".Split([IO.Path]::GetInvalidFileNameChars()) -join '_'
	$directoryname = $directoryname.Split("[") -join "(";
	$directoryname = $directoryname.Split("]") -join ")";
	
	# Create new directory for song
	New-Item -ItemType Directory -Force -Path "$directoryname"
	
	# Fetch cover for song
	try {
		$coverDownloadLink = ($videoSplits | Select-String -Pattern "co=").toString().replace("co=","");
		wget $coverDownloadLink -OutFile "$directoryname\cover.jpg"
	}
	catch {
		Write-Host "No cover available for $($songArtist) - $($songTitle)"
	}

	# Write Song Info File
	$newSongFileContent = $songFull;
	$replaceVideoWith = "#VIDEO:$($videoFileName)`r`n#COVER:cover.jpg"
	$newSongFileContent.replace($videoString.toString(), $replaceVideoWith) | Out-File -FilePath "$($directoryname)\$($directoryname).txt" -Encoding utf8
	
	# Download song audio
	if (-not ($songDownloadLink -eq $null)) {
		yt-dlp "https://youtube.com/watch/$songDownloadLink" -o "$($directoryname)\$($musicFileName)" -f ba -x --audio-format mp3
	}
	
	# Download song video
	if (-not ($videoDownloadLink -eq $null)) {
		yt-dlp "https://youtube.com/watch/$videoDownloadLink" -o "$($directoryname)\$($videoFileName)" -f "bv[fps<=30]" -S "res:720"
	}
	
	# Log
	Write-Host "DONE: $songArtist - $($songTitle)"
	}

