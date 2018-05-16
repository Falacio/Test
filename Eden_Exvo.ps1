[System.Collections.Hashtable]$Coinstats = @{}
[System.Collections.Hashtable]$Historic_Diff = @{}
$Logs_dir = "C:\Mineria\Mineros\Logs_Switcher"
$Log_file = "Log1"
$DefaultMiner = "CCminer"
$min_Diff = 1200
$max_Diff = 1400
$Default = "EDEN"
$DefaultPool = "HashFaster"
$Actual = ""
$AltCoin = "EXVO"
$AltPool = "EpicPool"
$MineCoins = @($Default, $AltCoin)

$Worker = "grumete"
$Cycle_Time = 300

$Log_Data =
@{
    Default = $Default
    Alt = $AltCoin
    Time_def = 0
    Time_alt = 0
    Avg_Diff_def = 0
    Avg_Diff_alt = 0
    Ticks = 0
}

$Pool_List =
@{
   "HashFaster" =
    @{
		Name = "HashFaster"
		PoolFee = 1
		Authless = $true
		Regions = $false
		ApiUrl = "http://hashfaster.com/api/status"
        	CoinsUrl = "http://hashfaster.com/api/currencies"
		Coins = 
        	@{
            		"EDEN" = @{ Server = "hashfaster.com:20015"} 
        	}
    }
     "Bsod" =
    @{
		Name = "Bsod"
		PoolFee = 1
		Authless = $true
		Regions = $false
		ApiUrl = "http://api.bsod.pw/api/status"
       		CoinsUrl = "http://api.bsod.pw/api/currencies"
		Coins = 
        	@{
            		"ADR" = @{ Server = "eu1.bsod.pw:2230"} 
        	}
    }
    "Gos" =
    @{
		Name = "Gos"
		PoolFee = 0
		Authless = $true
		Regions = $false
		ApiUrl = "https://www.gos.cx/api/status"
        	CoinsUrl = "https://www.gos.cx/api/currencies"	
        	Coins =
		@{
            		"ALPS" = @{ Server = "stratum.gos.cx:4555"}
            		"EXVO" = @{ Server = "stratum.gos.cx:4506"}
           		"ADR" = @{ Server = "stratum.gos.cx:8435"}
		}
    }
    "ThreeEyed" =
    @{
		Name = "ThreeEyed"
		PoolFee = 0
		Authless = $false
		Regions = $false
		ApiUrl = "http://www.gos.cx/api/status"
        	CoinsUrl = "http://www.gos.cx/api/currencies"	
        	Coins =
		@{
            		"RVN" = @{ Server = "stratum.threeeyed.info:3333"}
		}
    }
    "BlockCruncher" =
    @{
		Name = "BlockCruncher"
		PoolFee = 0.25
		Authless = $true
		Regions = $false
		ApiUrl = "http://blockcruncher.com/api/status"
        	CoinsUrl = "http://blockcruncher.com/api/currencies"
        	Coins =	
		@{
			"PGN" = @{ Server = "blockcruncher.com:3333"}
		}
    }
    "EpicPool" =
    @{
		Name = "EpicPool"
		PoolFee = 0.25
		Authless = $true
		Regions = $false
		ApiUrl = "http://epicpool.net/api/status"
        	CoinsUrl = "http://epicpool.net/api/currencies"
        	Coins =	
		@{
			"EXVO" = @{ Server = "epicpool.net:4544"}
		}
    }
}

$Miners =
@{
    "Nevermore"=
    @{
        Path = "C:\Mineria\Mineros\nevermore-win64"
        Type = "ccminer"
        Exe = "ccminer.exe"

    }
    "Excavator"=
    @{
        Path = "C:\Mineria\Mineros\Excavator"
        Type = "excavator"
        Exe = "excavator.exe"

    }
    "Skunk_ccminer"=
    @{
        Path = "C:\Mineria\Mineros\Skunk-NVIDIA"
        Type = "ccminer"
        Exe = "ccminer.exe"

    }
    "CCminer"=
    @{
        Path = "C:\Mineria\Mineros\ccminer-x64-2.2.5-cuda9"
        Type = "ccminer"
        Exe = "ccminer-x64.exe"

    }
}

$Coin_List =
@{
     "ADR" =
    @{
        Symbol = "ADR"
        Algo = "skunk"
        ExploUrl = "https://explorer.adirondack.io"
        Wallet = "<wallet_adress>"
        Intensity = "21"
        Miner = "Skunk_ccminer"
        Avg_Diff = 0
    }
    "EDEN" =
    @{
        Symbol = "EDEN"
        Algo = "x16s"
        ExploUrl = "http://explorer.reden.io"
        Wallet = "<wallet_adress>"
        Intensity = "20"
        Miner = "Nevermore"
        Avg_Diff = 0
    }
    "EXVO" =
    @{
        Symbol = "EXVO"
        Algo = "lyra2v2"
        ExploUrl = "https://explorer.exvo.io"
        Wallet = "<wallet_adress>"
        Intensity = "20"
        Miner = "Excavator"
        Avg_Diff = 0
    }
    "PGN" =
    @{
        Symbol = "PGN"
        Algo = "x16s"
        ExploUrl = "http://explorer.pigeoncoin.org"
        Wallet = "<wallet_adress>"
        Intensity = "20"
        Miner = "Nevermore"
        Avg_Diff = 0
    }
    "RVN" =
    @{
        Symbol = "RVN"
        Algo = "x16r"
        ExploUrl = "http://explorer.threeeyed.info"
        Wallet = "<wallet_adress>"
        Intensity = "20"
        Miner = "Nevermore"
        Avg_Diff = 0
    }
   "ALPS" =
    @{
        Symbol = "ALPS"
        Algo = "lyra2z"
        ExploUrl = "https://explorer.alpenschilling.cash"
        Wallet = "<wallet_adress>"
        Intensity = "20"
        Miner = "CCminer"
        Avg_Diff = 0
    }
}

function Write-Stats ($Coinstats)
{
    $Time =  Get-Date
    Write-Output $Time
    Write-Output ""
    Write-Output "* $($AltCoin): $($Coinstats[$AltCoin])"
    Write-Output "* $($Default): $($Coinstats[$Default])"
    Write-Output ""
    Write-Output "-----------------------------------------"
    Write-Output ""
}

function Create-Log
{
    if (-not (Test-Path "$($Logs_dir)")) {New-Item "$($Logs_dir)" -ItemType "directory" | Out-Null}
    $T = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
    try
	{
		New-Item "$($Logs_dir)\$($T).json" -ItemType File | Out-Null
	}
	catch
	{
		Write-Host "Error creating Log file!"
	}
    return $T
}

function Write-Log ($dta, $file)
{
    $CoinData = @{}
    $T = Get-Date -Format "yyyy-MM-dd HH-mm-ss"
    $CoinData.add($T, $dta)
    try
    {
        $CoinData | ConvertTo-Json | Add-Content -Path "$($Logs_dir)\$($file).json"
	}
	catch
	{
	    Write-Host "Error writing Log file!"
		Write-Host $_.Exception
	}
}

 
function Run_miner ([string]$C, [string]$P)
{
    $UseMiner = $Miners[$Coin_List[$C].Miner]
    switch ($UseMiner.Type)
    {
        Ccminer { Start-Process -FilePath "$($UseMiner.Path)\$($UseMiner.Exe)" -ArgumentList " -a $($Coin_List[$C].Algo) -o stratum+tcp://$($Pool_List[$P].Coins[$C].Server) -u $($Coin_List[$C].Wallet) -p $($Worker),c=$($C) -i $($Coin_List[$C].Intensity)" -PassThru }
        Excavator { Start-Process -FilePath "$($UseMiner.Path)\$($UseMiner.Exe)" -ArgumentList " -c $($UseMiner.Path)\$($C)_$($P).json -d 2 -f 6 -p 0 " -PassThru }
        default { Start-Process -FilePath "$($UseMiner.Path)\$($UseMiner.Exe)" -ArgumentList " -a $($Coin_List[$C].Algo) -o stratum+tcp://$($Pool_List[$P].Coins[$C].Server) -u $($Coin_List[$C].Wallet) -p $($Worker),c=$($C) -i $($Coin_List[$C].Intensity)" -PassThru }
    }    
}
    


function Check-Coins
{   
    [System.Collections.Hashtable]$Coinlist = @{}
    foreach ($Coin in $MineCoins)
    {
        try {$d = wget "$($Coin_List.$Coin.ExploUrl)/api/getdifficulty"}
        catch {$d = 9999}
        $Diff = ConvertFrom-Json $d
        $Coinlist.Add($Coin , $Diff)
    }
    return $Coinlist
}

#START

$Log_file = Create-Log
$Coinstats = Check-Coins
Write-Log $Coinstats $Log_file
Write-Stats $Coinstats 


if ($Coinstats.$AltCoin -le $min_Diff) { 
    $Proc = Run_miner $AltCoin $AltPool
    $Actual = $AltCoin
}
else {
    $Proc = Run_miner $Default $DefaultPool
    $Actual = $Default
}

while ($true) 
{
    if ($Coinstats.$AltCoin -le $min_Diff)
    { 
        if ($Actual -ne $AltCoin)
        {
            Stop-Process $Proc
            $Proc = Run_miner $AltCoin $AltPool
            $Actual = $AltCoin
        }
        
    }
    if ($Coinstats.$AltCoin -ge $max_Diff)
    { 
        if ($Actual -ne $Default)
        {
            Stop-Process $Proc
            $Proc = Run_miner $Default $DefaultPool
            $Actual = $Default
        }
    }
    Start-Sleep -Seconds $Cycle_Time
    $Coinstats = Check-Coins
    Write-Stats $Coinstats
    Write-Log $Coinstats $Log_file
}
