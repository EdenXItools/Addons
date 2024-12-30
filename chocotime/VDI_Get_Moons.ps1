function Get-MoonPhaseInfo {
    param (
        [Parameter(Mandatory)][string]$VD_Date,
        [Parameter(Mandatory)][string]$VD_Time
    )

    # Helper Functions
    function Get-VD_DayDif {
        param ([string]$EndDate)
        [string]$StartDate = "1468-07-07"
        $startParts = $StartDate -split "-"
        $endParts = $EndDate -split "-"
        $startYear = [int]$startParts[0]
        $startMonth = [int]$startParts[1]
        $startDay = [int]$startParts[2]
        $endYear = [int]$endParts[0]
        $endMonth = [int]$endParts[1]
        $endDay = [int]$endParts[2]
        $startTotalDays = (($startYear - 1) * 360) + (($startMonth - 1) * 30) + $startDay
        $endTotalDays = (($endYear - 1) * 360) + (($endMonth - 1) * 30) + $endDay
        return $endTotalDays - $startTotalDays
    }

    function Get-SecondsElapsed {
        param ([string]$TimeInput)
        $timeParts = $TimeInput -split ':'
        $hours = [int]$timeParts[0]
        $minutes = [int]$timeParts[1]
        $totalSeconds = ($hours * 3600) + ($minutes * 60)
        return $totalSeconds
    }

    function Convert-SecondsToTime {
        param ([double]$seconds)
        $hours = [math]::Floor($seconds / 3600)
        $minutes = [math]::Floor(($seconds % 3600) / 60)
        $remainingSeconds = [math]::Floor($seconds % 60)
        $formattedTime = "{0:00}:{1:00}:{2:00}" -f $hours, $minutes, $remainingSeconds
        return $formattedTime
    }

    # Moon Phase Data
    $moonPhases = @(
        [PSCustomObject]@{ "DayOfCycle" = 1; "Phase" = "Full Moon (90%)"; "NextPhaseDayOfCycle" = 8; "NextPhaseName" = "Waning Gibbous"; "VD_DaysUntilNextPhase" = 7; "VD_SecondsUntilNextPhase" = 604800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 42; "VD_SecondsUntilNextMajorMoon" = 3628800 },
        [PSCustomObject]@{ "DayOfCycle" = 2; "Phase" = "Full Moon (93%)"; "NextPhaseDayOfCycle" = 8; "NextPhaseName" = "Waning Gibbous"; "VD_DaysUntilNextPhase" = 6; "VD_SecondsUntilNextPhase" = 518400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 41; "VD_SecondsUntilNextMajorMoon" = 3542400 },
        [PSCustomObject]@{ "DayOfCycle" = 3; "Phase" = "Full Moon (95%)"; "NextPhaseDayOfCycle" = 8; "NextPhaseName" = "Waning Gibbous"; "VD_DaysUntilNextPhase" = 5; "VD_SecondsUntilNextPhase" = 432000; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 40; "VD_SecondsUntilNextMajorMoon" = 3456000 },
        [PSCustomObject]@{ "DayOfCycle" = 4; "Phase" = "Full Moon (98%)"; "NextPhaseDayOfCycle" = 8; "NextPhaseName" = "Waning Gibbous"; "VD_DaysUntilNextPhase" = 4; "VD_SecondsUntilNextPhase" = 345600; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 39; "VD_SecondsUntilNextMajorMoon" = 3369600 },
        [PSCustomObject]@{ "DayOfCycle" = 5; "Phase" = "Full Moon (100%)"; "NextPhaseDayOfCycle" = 8; "NextPhaseName" = "Waning Gibbous"; "VD_DaysUntilNextPhase" = 3; "VD_SecondsUntilNextPhase" = 259200; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 38; "VD_SecondsUntilNextMajorMoon" = 3283200 },
        [PSCustomObject]@{ "DayOfCycle" = 6; "Phase" = "Full Moon (98%)"; "NextPhaseDayOfCycle" = 8; "NextPhaseName" = "Waning Gibbous"; "VD_DaysUntilNextPhase" = 2; "VD_SecondsUntilNextPhase" = 172800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 37; "VD_SecondsUntilNextMajorMoon" = 3196800 },
        [PSCustomObject]@{ "DayOfCycle" = 7; "Phase" = "Full Moon (95%)"; "NextPhaseDayOfCycle" = 8; "NextPhaseName" = "Waning Gibbous"; "VD_DaysUntilNextPhase" = 1; "VD_SecondsUntilNextPhase" = 86400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 36; "VD_SecondsUntilNextMajorMoon" = 3110400 },
        [PSCustomObject]@{ "DayOfCycle" = 8; "Phase" = "Waning Gibbous (93%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 14; "VD_SecondsUntilNextPhase" = 1209600; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 35; "VD_SecondsUntilNextMajorMoon" = 3024000 },
        [PSCustomObject]@{ "DayOfCycle" = 9; "Phase" = "Waning Gibbous (90%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 13; "VD_SecondsUntilNextPhase" = 1123200; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 34; "VD_SecondsUntilNextMajorMoon" = 2937600 },
        [PSCustomObject]@{ "DayOfCycle" = 10; "Phase" = "Waning Gibbous (88%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 12; "VD_SecondsUntilNextPhase" = 1036800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 33; "VD_SecondsUntilNextMajorMoon" = 2851200 },
        [PSCustomObject]@{ "DayOfCycle" = 11; "Phase" = "Waning Gibbous (86%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 11; "VD_SecondsUntilNextPhase" = 950400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 32; "VD_SecondsUntilNextMajorMoon" = 2764800 },
        [PSCustomObject]@{ "DayOfCycle" = 12; "Phase" = "Waning Gibbous (83%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 10; "VD_SecondsUntilNextPhase" = 864000; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 31; "VD_SecondsUntilNextMajorMoon" = 2678400 },
        [PSCustomObject]@{ "DayOfCycle" = 13; "Phase" = "Waning Gibbous (81%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 9; "VD_SecondsUntilNextPhase" = 777600; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 30; "VD_SecondsUntilNextMajorMoon" = 2592000 },
        [PSCustomObject]@{ "DayOfCycle" = 14; "Phase" = "Waning Gibbous (79%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 8; "VD_SecondsUntilNextPhase" = 691200; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 29; "VD_SecondsUntilNextMajorMoon" = 2505600 },
        [PSCustomObject]@{ "DayOfCycle" = 15; "Phase" = "Waning Gibbous (76%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 7; "VD_SecondsUntilNextPhase" = 604800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 28; "VD_SecondsUntilNextMajorMoon" = 2419200 },
        [PSCustomObject]@{ "DayOfCycle" = 16; "Phase" = "Waning Gibbous (74%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 6; "VD_SecondsUntilNextPhase" = 518400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 27; "VD_SecondsUntilNextMajorMoon" = 2332800 },
        [PSCustomObject]@{ "DayOfCycle" = 17; "Phase" = "Waning Gibbous (71%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 5; "VD_SecondsUntilNextPhase" = 432000; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 26; "VD_SecondsUntilNextMajorMoon" = 2246400 },
        [PSCustomObject]@{ "DayOfCycle" = 18; "Phase" = "Waning Gibbous (69%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 4; "VD_SecondsUntilNextPhase" = 345600; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 25; "VD_SecondsUntilNextMajorMoon" = 2160000 },
        [PSCustomObject]@{ "DayOfCycle" = 19; "Phase" = "Waning Gibbous (67%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 3; "VD_SecondsUntilNextPhase" = 259200; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 24; "VD_SecondsUntilNextMajorMoon" = 2073600 },
        [PSCustomObject]@{ "DayOfCycle" = 20; "Phase" = "Waning Gibbous (64%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 2; "VD_SecondsUntilNextPhase" = 172800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 23; "VD_SecondsUntilNextMajorMoon" = 1987200 },
        [PSCustomObject]@{ "DayOfCycle" = 21; "Phase" = "Waning Gibbous (62%)"; "NextPhaseDayOfCycle" = 22; "NextPhaseName" = "Last Quarter"; "VD_DaysUntilNextPhase" = 1; "VD_SecondsUntilNextPhase" = 86400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 22; "VD_SecondsUntilNextMajorMoon" = 1900800 },
        [PSCustomObject]@{ "DayOfCycle" = 22; "Phase" = "Last Quarter (60%)"; "NextPhaseDayOfCycle" = 30; "NextPhaseName" = "Waning Crescent"; "VD_DaysUntilNextPhase" = 8; "VD_SecondsUntilNextPhase" = 691200; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 21; "VD_SecondsUntilNextMajorMoon" = 1814400 },
        [PSCustomObject]@{ "DayOfCycle" = 23; "Phase" = "Last Quarter (57%)"; "NextPhaseDayOfCycle" = 30; "NextPhaseName" = "Waning Crescent"; "VD_DaysUntilNextPhase" = 7; "VD_SecondsUntilNextPhase" = 604800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 20; "VD_SecondsUntilNextMajorMoon" = 1728000 },
        [PSCustomObject]@{ "DayOfCycle" = 24; "Phase" = "Last Quarter (55%)"; "NextPhaseDayOfCycle" = 30; "NextPhaseName" = "Waning Crescent"; "VD_DaysUntilNextPhase" = 6; "VD_SecondsUntilNextPhase" = 518400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 19; "VD_SecondsUntilNextMajorMoon" = 1641600 },
        [PSCustomObject]@{ "DayOfCycle" = 25; "Phase" = "Last Quarter (52%)"; "NextPhaseDayOfCycle" = 30; "NextPhaseName" = "Waning Crescent"; "VD_DaysUntilNextPhase" = 5; "VD_SecondsUntilNextPhase" = 432000; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 18; "VD_SecondsUntilNextMajorMoon" = 1555200 },
        [PSCustomObject]@{ "DayOfCycle" = 26; "Phase" = "Last Quarter (50%)"; "NextPhaseDayOfCycle" = 30; "NextPhaseName" = "Waning Crescent"; "VD_DaysUntilNextPhase" = 4; "VD_SecondsUntilNextPhase" = 345600; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 17; "VD_SecondsUntilNextMajorMoon" = 1468800 },
        [PSCustomObject]@{ "DayOfCycle" = 27; "Phase" = "Last Quarter (48%)"; "NextPhaseDayOfCycle" = 30; "NextPhaseName" = "Waning Crescent"; "VD_DaysUntilNextPhase" = 3; "VD_SecondsUntilNextPhase" = 259200; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 16; "VD_SecondsUntilNextMajorMoon" = 1382400 },
        [PSCustomObject]@{ "DayOfCycle" = 28; "Phase" = "Last Quarter (45%)"; "NextPhaseDayOfCycle" = 30; "NextPhaseName" = "Waning Crescent"; "VD_DaysUntilNextPhase" = 2; "VD_SecondsUntilNextPhase" = 172800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 15; "VD_SecondsUntilNextMajorMoon" = 1296000 },
        [PSCustomObject]@{ "DayOfCycle" = 29; "Phase" = "Last Quarter (43%)"; "NextPhaseDayOfCycle" = 30; "NextPhaseName" = "Waning Crescent"; "VD_DaysUntilNextPhase" = 1; "VD_SecondsUntilNextPhase" = 86400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 14; "VD_SecondsUntilNextMajorMoon" = 1209600 },
        [PSCustomObject]@{ "DayOfCycle" = 30; "Phase" = "Waning Crescent (40%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 13; "VD_SecondsUntilNextPhase" = 1123200; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 13; "VD_SecondsUntilNextMajorMoon" = 1123200 },
        [PSCustomObject]@{ "DayOfCycle" = 31; "Phase" = "Waning Crescent (38%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 12; "VD_SecondsUntilNextPhase" = 1036800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 12; "VD_SecondsUntilNextMajorMoon" = 1036800 },
        [PSCustomObject]@{ "DayOfCycle" = 32; "Phase" = "Waning Crescent (36%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 11; "VD_SecondsUntilNextPhase" = 950400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 11; "VD_SecondsUntilNextMajorMoon" = 950400 },
        [PSCustomObject]@{ "DayOfCycle" = 33; "Phase" = "Waning Crescent (33%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 10; "VD_SecondsUntilNextPhase" = 864000; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 10; "VD_SecondsUntilNextMajorMoon" = 864000 },
        [PSCustomObject]@{ "DayOfCycle" = 34; "Phase" = "Waning Crescent (31%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 9; "VD_SecondsUntilNextPhase" = 777600; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 9; "VD_SecondsUntilNextMajorMoon" = 777600 },
        [PSCustomObject]@{ "DayOfCycle" = 35; "Phase" = "Waning Crescent (29%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 8; "VD_SecondsUntilNextPhase" = 691200; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 8; "VD_SecondsUntilNextMajorMoon" = 691200 },
        [PSCustomObject]@{ "DayOfCycle" = 36; "Phase" = "Waning Crescent (26%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 7; "VD_SecondsUntilNextPhase" = 604800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 7; "VD_SecondsUntilNextMajorMoon" = 604800 },
        [PSCustomObject]@{ "DayOfCycle" = 37; "Phase" = "Waning Crescent (24%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 6; "VD_SecondsUntilNextPhase" = 518400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 6; "VD_SecondsUntilNextMajorMoon" = 518400 },
        [PSCustomObject]@{ "DayOfCycle" = 38; "Phase" = "Waning Crescent (21%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 5; "VD_SecondsUntilNextPhase" = 432000; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 5; "VD_SecondsUntilNextMajorMoon" = 432000 },
        [PSCustomObject]@{ "DayOfCycle" = 39; "Phase" = "Waning Crescent (19%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 4; "VD_SecondsUntilNextPhase" = 345600; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 4; "VD_SecondsUntilNextMajorMoon" = 345600 },
        [PSCustomObject]@{ "DayOfCycle" = 40; "Phase" = "Waning Crescent (17%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 3; "VD_SecondsUntilNextPhase" = 259200; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 3; "VD_SecondsUntilNextMajorMoon" = 259200 },
        [PSCustomObject]@{ "DayOfCycle" = 41; "Phase" = "Waning Crescent (14%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 2; "VD_SecondsUntilNextPhase" = 172800; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 2; "VD_SecondsUntilNextMajorMoon" = 172800 },
        [PSCustomObject]@{ "DayOfCycle" = 42; "Phase" = "Waning Crescent (12%)"; "NextPhaseDayOfCycle" = 43; "NextPhaseName" = "New Moon"; "VD_DaysUntilNextPhase" = 1; "VD_SecondsUntilNextPhase" = 86400; "NextMajorMoon" = "New Moon"; "VD_DaysUntilNextMajorMoon" = 1; "VD_SecondsUntilNextMajorMoon" = 86400 },
        [PSCustomObject]@{ "DayOfCycle" = 43; "Phase" = "New Moon (10%)"; "NextPhaseDayOfCycle" = 50; "NextPhaseName" = "Waxing Crescent"; "VD_DaysUntilNextPhase" = 7; "VD_SecondsUntilNextPhase" = 604800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 42; "VD_SecondsUntilNextMajorMoon" = 3628800 },
        [PSCustomObject]@{ "DayOfCycle" = 44; "Phase" = "New Moon (7%)"; "NextPhaseDayOfCycle" = 50; "NextPhaseName" = "Waxing Crescent"; "VD_DaysUntilNextPhase" = 6; "VD_SecondsUntilNextPhase" = 518400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 41; "VD_SecondsUntilNextMajorMoon" = 3542400 },
        [PSCustomObject]@{ "DayOfCycle" = 45; "Phase" = "New Moon (5%)"; "NextPhaseDayOfCycle" = 50; "NextPhaseName" = "Waxing Crescent"; "VD_DaysUntilNextPhase" = 5; "VD_SecondsUntilNextPhase" = 432000; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 40; "VD_SecondsUntilNextMajorMoon" = 3456000 },
        [PSCustomObject]@{ "DayOfCycle" = 46; "Phase" = "New Moon (2%)"; "NextPhaseDayOfCycle" = 50; "NextPhaseName" = "Waxing Crescent"; "VD_DaysUntilNextPhase" = 4; "VD_SecondsUntilNextPhase" = 345600; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 39; "VD_SecondsUntilNextMajorMoon" = 3369600 },
        [PSCustomObject]@{ "DayOfCycle" = 47; "Phase" = "New Moon (0%)"; "NextPhaseDayOfCycle" = 50; "NextPhaseName" = "Waxing Crescent"; "VD_DaysUntilNextPhase" = 3; "VD_SecondsUntilNextPhase" = 259200; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 38; "VD_SecondsUntilNextMajorMoon" = 3283200 },
        [PSCustomObject]@{ "DayOfCycle" = 48; "Phase" = "New Moon (2%)"; "NextPhaseDayOfCycle" = 50; "NextPhaseName" = "Waxing Crescent"; "VD_DaysUntilNextPhase" = 2; "VD_SecondsUntilNextPhase" = 172800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 37; "VD_SecondsUntilNextMajorMoon" = 3196800 },
        [PSCustomObject]@{ "DayOfCycle" = 49; "Phase" = "New Moon (5%)"; "NextPhaseDayOfCycle" = 50; "NextPhaseName" = "Waxing Crescent"; "VD_DaysUntilNextPhase" = 1; "VD_SecondsUntilNextPhase" = 86400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 36; "VD_SecondsUntilNextMajorMoon" = 3110400 },
        [PSCustomObject]@{ "DayOfCycle" = 50; "Phase" = "Waxing Crescent (7%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 14; "VD_SecondsUntilNextPhase" = 1209600; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 35; "VD_SecondsUntilNextMajorMoon" = 3024000 },
        [PSCustomObject]@{ "DayOfCycle" = 51; "Phase" = "Waxing Crescent (10%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 13; "VD_SecondsUntilNextPhase" = 1123200; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 34; "VD_SecondsUntilNextMajorMoon" = 2937600 },
        [PSCustomObject]@{ "DayOfCycle" = 52; "Phase" = "Waxing Crescent (12%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 12; "VD_SecondsUntilNextPhase" = 1036800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 33; "VD_SecondsUntilNextMajorMoon" = 2851200 },
        [PSCustomObject]@{ "DayOfCycle" = 53; "Phase" = "Waxing Crescent (14%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 11; "VD_SecondsUntilNextPhase" = 950400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 32; "VD_SecondsUntilNextMajorMoon" = 2764800 },
        [PSCustomObject]@{ "DayOfCycle" = 54; "Phase" = "Waxing Crescent (17%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 10; "VD_SecondsUntilNextPhase" = 864000; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 31; "VD_SecondsUntilNextMajorMoon" = 2678400 },
        [PSCustomObject]@{ "DayOfCycle" = 55; "Phase" = "Waxing Crescent (19%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 9; "VD_SecondsUntilNextPhase" = 777600; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 30; "VD_SecondsUntilNextMajorMoon" = 2592000 },
        [PSCustomObject]@{ "DayOfCycle" = 56; "Phase" = "Waxing Crescent (21%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 8; "VD_SecondsUntilNextPhase" = 691200; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 29; "VD_SecondsUntilNextMajorMoon" = 2505600 },
        [PSCustomObject]@{ "DayOfCycle" = 57; "Phase" = "Waxing Crescent (24%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 7; "VD_SecondsUntilNextPhase" = 604800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 28; "VD_SecondsUntilNextMajorMoon" = 2419200 },
        [PSCustomObject]@{ "DayOfCycle" = 58; "Phase" = "Waxing Crescent (26%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 6; "VD_SecondsUntilNextPhase" = 518400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 27; "VD_SecondsUntilNextMajorMoon" = 2332800 },
        [PSCustomObject]@{ "DayOfCycle" = 59; "Phase" = "Waxing Crescent (29%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 5; "VD_SecondsUntilNextPhase" = 432000; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 26; "VD_SecondsUntilNextMajorMoon" = 2246400 },
        [PSCustomObject]@{ "DayOfCycle" = 60; "Phase" = "Waxing Crescent (31%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 4; "VD_SecondsUntilNextPhase" = 345600; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 25; "VD_SecondsUntilNextMajorMoon" = 2160000 },
        [PSCustomObject]@{ "DayOfCycle" = 61; "Phase" = "Waxing Crescent (33%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 3; "VD_SecondsUntilNextPhase" = 259200; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 24; "VD_SecondsUntilNextMajorMoon" = 2073600 },
        [PSCustomObject]@{ "DayOfCycle" = 62; "Phase" = "Waxing Crescent (36%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 2; "VD_SecondsUntilNextPhase" = 172800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 23; "VD_SecondsUntilNextMajorMoon" = 1987200 },
        [PSCustomObject]@{ "DayOfCycle" = 63; "Phase" = "Waxing Crescent (38%)"; "NextPhaseDayOfCycle" = 64; "NextPhaseName" = "First Quarter"; "VD_DaysUntilNextPhase" = 1; "VD_SecondsUntilNextPhase" = 86400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 22; "VD_SecondsUntilNextMajorMoon" = 1900800 },
        [PSCustomObject]@{ "DayOfCycle" = 64; "Phase" = "First Quarter (40%)"; "NextPhaseDayOfCycle" = 71; "NextPhaseName" = "Waxing Gibbous"; "VD_DaysUntilNextPhase" = 7; "VD_SecondsUntilNextPhase" = 604800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 21; "VD_SecondsUntilNextMajorMoon" = 1814400 },
        [PSCustomObject]@{ "DayOfCycle" = 65; "Phase" = "First Quarter (43%)"; "NextPhaseDayOfCycle" = 71; "NextPhaseName" = "Waxing Gibbous"; "VD_DaysUntilNextPhase" = 6; "VD_SecondsUntilNextPhase" = 518400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 20; "VD_SecondsUntilNextMajorMoon" = 1728000 },
        [PSCustomObject]@{ "DayOfCycle" = 66; "Phase" = "First Quarter (45%)"; "NextPhaseDayOfCycle" = 71; "NextPhaseName" = "Waxing Gibbous"; "VD_DaysUntilNextPhase" = 5; "VD_SecondsUntilNextPhase" = 432000; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 19; "VD_SecondsUntilNextMajorMoon" = 1641600 },
        [PSCustomObject]@{ "DayOfCycle" = 67; "Phase" = "First Quarter (48%)"; "NextPhaseDayOfCycle" = 71; "NextPhaseName" = "Waxing Gibbous"; "VD_DaysUntilNextPhase" = 4; "VD_SecondsUntilNextPhase" = 345600; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 18; "VD_SecondsUntilNextMajorMoon" = 1555200 },
        [PSCustomObject]@{ "DayOfCycle" = 68; "Phase" = "First Quarter (50%)"; "NextPhaseDayOfCycle" = 71; "NextPhaseName" = "Waxing Gibbous"; "VD_DaysUntilNextPhase" = 3; "VD_SecondsUntilNextPhase" = 259200; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 17; "VD_SecondsUntilNextMajorMoon" = 1468800 },
        [PSCustomObject]@{ "DayOfCycle" = 69; "Phase" = "First Quarter (52%)"; "NextPhaseDayOfCycle" = 71; "NextPhaseName" = "Waxing Gibbous"; "VD_DaysUntilNextPhase" = 2; "VD_SecondsUntilNextPhase" = 172800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 16; "VD_SecondsUntilNextMajorMoon" = 1382400 },
        [PSCustomObject]@{ "DayOfCycle" = 70; "Phase" = "First Quarter (55%)"; "NextPhaseDayOfCycle" = 71; "NextPhaseName" = "Waxing Gibbous"; "VD_DaysUntilNextPhase" = 1; "VD_SecondsUntilNextPhase" = 86400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 15; "VD_SecondsUntilNextMajorMoon" = 1296000 },
        [PSCustomObject]@{ "DayOfCycle" = 71; "Phase" = "Waxing Gibbous (57%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 14; "VD_SecondsUntilNextPhase" = 1209600; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 14; "VD_SecondsUntilNextMajorMoon" = 1209600 },
        [PSCustomObject]@{ "DayOfCycle" = 72; "Phase" = "Waxing Gibbous (60%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 13; "VD_SecondsUntilNextPhase" = 1123200; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 13; "VD_SecondsUntilNextMajorMoon" = 1123200 },
        [PSCustomObject]@{ "DayOfCycle" = 73; "Phase" = "Waxing Gibbous (62%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 12; "VD_SecondsUntilNextPhase" = 1036800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 12; "VD_SecondsUntilNextMajorMoon" = 1036800 },
        [PSCustomObject]@{ "DayOfCycle" = 74; "Phase" = "Waxing Gibbous (64%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 11; "VD_SecondsUntilNextPhase" = 950400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 11; "VD_SecondsUntilNextMajorMoon" = 950400 },
        [PSCustomObject]@{ "DayOfCycle" = 75; "Phase" = "Waxing Gibbous (67%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 10; "VD_SecondsUntilNextPhase" = 864000; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 10; "VD_SecondsUntilNextMajorMoon" = 864000 },
        [PSCustomObject]@{ "DayOfCycle" = 76; "Phase" = "Waxing Gibbous (69%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 9; "VD_SecondsUntilNextPhase" = 777600; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 9; "VD_SecondsUntilNextMajorMoon" = 777600 },
        [PSCustomObject]@{ "DayOfCycle" = 77; "Phase" = "Waxing Gibbous (71%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 8; "VD_SecondsUntilNextPhase" = 691200; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 8; "VD_SecondsUntilNextMajorMoon" = 691200 },
        [PSCustomObject]@{ "DayOfCycle" = 78; "Phase" = "Waxing Gibbous (74%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 7; "VD_SecondsUntilNextPhase" = 604800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 7; "VD_SecondsUntilNextMajorMoon" = 604800 },
        [PSCustomObject]@{ "DayOfCycle" = 79; "Phase" = "Waxing Gibbous (76%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 6; "VD_SecondsUntilNextPhase" = 518400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 6; "VD_SecondsUntilNextMajorMoon" = 518400 },
        [PSCustomObject]@{ "DayOfCycle" = 80; "Phase" = "Waxing Gibbous (79%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 5; "VD_SecondsUntilNextPhase" = 432000; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 5; "VD_SecondsUntilNextMajorMoon" = 432000 },
        [PSCustomObject]@{ "DayOfCycle" = 81; "Phase" = "Waxing Gibbous (81%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 4; "VD_SecondsUntilNextPhase" = 345600; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 4; "VD_SecondsUntilNextMajorMoon" = 345600 },
        [PSCustomObject]@{ "DayOfCycle" = 82; "Phase" = "Waxing Gibbous (83%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 3; "VD_SecondsUntilNextPhase" = 259200; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 3; "VD_SecondsUntilNextMajorMoon" = 259200 },
        [PSCustomObject]@{ "DayOfCycle" = 83; "Phase" = "Waxing Gibbous (86%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 2; "VD_SecondsUntilNextPhase" = 172800; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 2; "VD_SecondsUntilNextMajorMoon" = 172800 },
        [PSCustomObject]@{ "DayOfCycle" = 84; "Phase" = "Waxing Gibbous (88%)"; "NextPhaseDayOfCycle" = 1; "NextPhaseName" = "Full Moon"; "VD_DaysUntilNextPhase" = 1; "VD_SecondsUntilNextPhase" = 86400; "NextMajorMoon" = "Full Moon"; "VD_DaysUntilNextMajorMoon" = 1; "VD_SecondsUntilNextMajorMoon" = 86400 }
    )

    # Calculate Cycle Day and Time Elapsed
    $VD_DayDif = Get-VD_DayDif -EndDate $VD_Date
    $CycleDay = ($VD_DayDif % 84) + 1
    $VD_TimeElapsed = Get-SecondsElapsed -TimeInput $VD_Time

    # Find the current moon phase information
    $currentPhase = $moonPhases | Where-Object { $_.DayOfCycle -eq $CycleDay } | Select-Object -First 1
    if (-not $currentPhase) {throw "Cycle day not found in moon phase data."}

    $CurrentMoonPhase = $currentPhase.Phase
    $NextPhaseName = $currentPhase.NextPhaseName
    $VD_SecondsUntilNextPhase = $currentPhase.VD_SecondsUntilNextPhase
    $NextMajorMoon = $currentPhase.NextMajorMoon
    $VD_SecondsUntilNextMajorMoon = $currentPhase.VD_SecondsUntilNextMajorMoon

    # Calculate Earth time until the next phases
    $Earth_SecondsUntilNextPhase = ($VD_SecondsUntilNextPhase - $VD_TimeElapsed) / 25
    $Earth_SecondsUntilNextMajorMoon = ($VD_SecondsUntilNextMajorMoon - $VD_TimeElapsed) / 25

    $TimeUntilNextPhase = Convert-SecondsToTime -seconds $Earth_SecondsUntilNextPhase
    $TimeUntilNextMajorMoon = Convert-SecondsToTime -seconds $Earth_SecondsUntilNextMajorMoon

    # Return results
    return [PSCustomObject]@{
        CurrentMoonPhase = $CurrentMoonPhase
        NextPhase = $NextPhaseName
        TimeUntilNextPhase = $TimeUntilNextPhase
        NextMajorMoon = $NextMajorMoon
        TimeUntilNextMajorMoon = $TimeUntilNextMajorMoon
    }
}
$VD_Date = '1469-05-04'
$VD_Time = '06:14'
$Result = Get-MoonPhaseInfo -VD_Date $VD_Date -VD_Time $VD_Time
$Result | ConvertTo-Json -Depth 3