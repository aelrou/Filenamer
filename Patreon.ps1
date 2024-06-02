$postTitle = Get-Clipboard -Raw

function RemoveFilesystemCharacters {
    Param([string]$inputString)
    $inputString = $inputString.Replace("$([char]34)", "$([char]32)")
    $inputString = $inputString.Replace("$([char]42)", "$([char]32)")
    $inputString = $inputString.Replace("$([char]47)", "$([char]32)")
    $inputString = $inputString.Replace("$([char]58)", "$([char]32)")
    $inputString = $inputString.Replace("$([char]60)", "$([char]32)")
    $inputString = $inputString.Replace("$([char]62)", "$([char]32)")
    $inputString = $inputString.Replace("$([char]63)", "$([char]32)")
    $inputString = $inputString.Replace("$([char]92)", "$([char]32)")
    $inputString = $inputString.Replace("$([char]124)", "$([char]32)")
    return $inputString
}

function RemoveLineBreaks {
    Param([string]$inputString)
    $lines = $inputString -split "`r`n"
    [string]$singleLine = $null
    $firstLine = $true
    foreach($line in $lines){
        if ($firstLine) {
            $firstLine = $false
            $singleLine = "$($line)"
        }
        else {
            $singleLine = "$($singleLine) $($line)"
        }
    }
    return $singleLine
}

function RemoveConsecutiveSpaces {
    Param([string]$inputString)
    while ($true) {
        if ($inputString.Contains("$([char]32)$([char]32)")) {
            $inputString = $inputString.Replace("$([char]32)$([char]32)", "$([char]32)")
        }
        else {
            break
        }
    }
    return $inputString
}

$postLines = ($postTitle -split '\r?\n').Trim()
[int]$lineCount = $null
$lineCount = $postLines.Length
#Write-Host($lineCount)
[string]$whole = $null
[string]$month = $null
[string]$day = $null
[string]$year = $null
[int]$loopCount = 0
[int]$dateIndex = $null
foreach ($line in $postLines) {
    if ($line -match "^([a-jA-Jl-pL-Pr-vR-VyY]{3,9})\s([0-1]?[0-9]+)\,\s([1-2][09][0-9][0-9])") {
        #Write-Host("pattern match on $($loopCount)")
        $whole = $Matches.0
        $month = $Matches.1
        $day = $Matches.2
        $year = $Matches.3
        $dateIndex = $loopCount
        break
    }
    #Write-Host("no match on $($loopCount)")
    $loopCount = $loopCount + 1
}
# Write-Host("content of $($dateIndex): $($postLines[$dateIndex])")
# Write-Host($whole)
# Write-Host($month)
# Write-Host($day)
# Write-Host($year)
# Write-Host($dateIndex)

[string]$postName = $null
try {
    $postName = [datetime]::parseexact("$($year)-$($month)-$($day)", "yyyy-MMM-dd", $null).ToString("yyyy-MM-dd")
# Write-Host "2: $($postName)"
}
catch {
    try {
        $postName = [datetime]::parseexact("$($year)-$($month)-$($day)", "yyyy-MMM-d", $null).ToString("yyyy-MM-dd")
# Write-Host "3: $($postName)"
    }
    catch {
# Write-Host "5: $($postName)"
        <#Do this if a terminating exception happens#>
    }    
# Write-Host "6: $($postName)"
    <#Do this if a terminating exception happens#>
}

$loopCount = 0
foreach ($line in $postLines) {
    if($loopCount -ne $dateIndex){
        $postName = "$($postName) $($line)"
    }
    $loopCount = $loopCount + 1
}

# Write-Host "7: $($postName)"

$postName = RemoveFilesystemCharacters($postName)
# Write-Host "8: $($postName)"
# $postName = RemoveLineBreaks($postName)
# Write-Host "9: $($postName)"
$postName = RemoveConsecutiveSpaces($postName)
# Write-Host "10: $($postName)"
Set-Clipboard -Value $postName.trim()

Exit(0)
