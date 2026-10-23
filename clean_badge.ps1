$path = 'd:\ikon.utama\index.html'
$lines = [System.IO.File]::ReadAllLines($path)

# Let's inspect around line 590
# We want to replace the badge div cleanly
$newLines = [System.Collections.Generic.List[string]]::new()
$skip = $false

for ($i = 0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    if ($line -like "*bg-navy px-6 py-5 md:px-8 md:py-6 rounded-2xl shadow-2xl z-20*") {
        $newLines.Add('                    <div class="absolute -top-6 right-6 lg:-right-10 lg:top-10 bg-navy px-6 py-5 md:px-8 md:py-6 rounded-2xl shadow-2xl z-20 max-w-[210px] text-center border border-white/10">')
        $newLines.Add('                        <p class="text-white/80 text-xs md:text-sm font-medium leading-snug mb-2">')
        $newLines.Add('                            Memiliki pengalaman lebih dari')
        $newLines.Add('                        </p>')
        $newLines.Add('                        <div class="flex items-baseline justify-center gap-1.5 text-baby-blue">')
        $newLines.Add('                            <span class="text-4xl md:text-5xl font-extrabold tracking-tight leading-none">20</span>')
        $newLines.Add('                            <span class="text-lg md:text-xl font-bold">Tahun</span>')
        $newLines.Add('                        </div>')
        $newLines.Add('                    </div>')
        $skip = $true
        continue
    }
    if ($skip) {
        if ($line.Trim() -eq '</div>' -and $lines[$i+1] -like "*space-y-12 reveal-right*") {
            # This is the closing div of the relative image container
            $skip = $false
            $newLines.Add($line)
        }
        continue
    }
    $newLines.Add($line)
}

[System.IO.File]::WriteAllLines($path, $newLines, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Updated successfully"
