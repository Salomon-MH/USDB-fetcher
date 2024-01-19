# USDB-fetcher
PowerShell script to make UltraStar songs from USDB (usdb.animux.de) available offline.  
Works with any kind of UltraStar song text file, as long as it matches the syntax - most importantly has a #VIDEO:v=... or #VIDEO:a=... tag in it.

## Preconditions
- Install yt-dlp, so that it is available in your PATH variable (i.e. you can call the yt-dlp command directly in your terminal)
- Create a .\toFetch\ subdirectory and place a few .txt files in it. These files are your UltraStar Deluxe song files. Their file name doesn't matter, only their file endings.

## Usage
After placing the .txt file(s) in the toFetch directory, just run the script. It'll create subdirectories in the script's root directory called ARTIST - TITLE, with the songs, videos and edited .txt files in it.  
Videos are downloaded at maximum in 720p (non 60 FPS) without audio (as audio is placed separately in the .mp3 file). This is to be able to use the videos also on very low-end systems and to save on storage.

## Why?
To have the full songs ready to play offline! :)  
Nobody can take them from you, once they're save on your drive... Well, except a drive failure of course.

## Disclaimer
Made for personal use only. Redistribution to other websites or similar of this script is strictly forbidden.  
No warranty on anything. If you find a bug, feel free to create a pull request. ;)
