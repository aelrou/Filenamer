$postTimeStamp = Get-Clipboard -Raw

Write-Host "1: $($postTimeStamp)"

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

# \r\n\x0b\f\x85\x2028\x2029
if ($postTimeStamp -match "^([a-jA-Jl-pL-Pr-vR-VyY]{3,9})\s([0-1]?[0-9]+)\,\s([1-2][09][0-9][0-9])\s?([^\n\r]*)[\n\r]*([^\n\r]*)[\n\r]*([^\n\r]*)[\n\r]*([^\n\r]*)[\n\r]*([^\n\r]*)") {
    [string]$whole = $Matches.0
    [string]$month = $Matches.1
    [string]$day = $Matches.2
    [string]$year = $Matches.3
    [string]$group4 = $Matches.4
    [string]$group5 = $Matches.5
    [string]$group6 = $Matches.6
    [string]$group7 = $Matches.7
    [string]$group8 = $Matches.8

    [string]$postName = $null
    
    try {
        $postName = [datetime]::parseexact("$($year)-$($month)-$($day)", "yyyy-MMM-dd", $null).ToString("yyyy-MM-dd")
   Write-Host "2: $($postName)"
    }
    catch {
        try {
            $postName = [datetime]::parseexact("$($year)-$($month)-$($day)", "yyyy-MMM-d", $null).ToString("yyyy-MM-dd")
   Write-Host "3: $($postName)"
        }
        catch {
   Write-Host "5: $($postName)"
            <#Do this if a terminating exception happens#>
        }    
   Write-Host "6: $($postName)"
        <#Do this if a terminating exception happens#>
    }

    if (!$group5 -eq "") {
        if (!$group5.Contains("Public post")) {
            $group5 = RemoveFilesystemCharacters($group5)
            $postName = "$($postName) $($group5)"
        }
    }
    
    if (!$group6 -eq "") {
        if (!$group6.Contains("Public post")) {
            $group6 = RemoveFilesystemCharacters($group6)
            $postName = "$($postName) $($group6)"
        }
    }
    
    if (!$group7 -eq "") {
        if (!$group7.Contains("Public post")) {
            $group7 = RemoveFilesystemCharacters($group7)
            $postName = "$($postName) $($group7)"
        }
    }
    if (!$group8 -eq "") {
        if (!$group8.Contains("Public post")) {
            $group8 = RemoveFilesystemCharacters($group8)
            $postName = "$($postName) $($group8)"
        }
    }
    
    $postName = RemoveConsecutiveSpaces($postName)
   Write-Host "4: $($postName)"
    Set-Clipboard -Value $postName
    Write-Host $postName
}
else {
    [string]$postName = RemoveFilesystemCharacters($postTimeStamp)
   Write-Host "7: $($postName)"
    $postName = RemoveLineBreaks($postName)
   Write-Host "8: $($postName)"
    $postName = RemoveConsecutiveSpaces($postName)
   Write-Host "9: $($postName)"
    Set-Clipboard -Value $postName
    # Write-Host $now.ToString("yyyy-MM-dd")
}
