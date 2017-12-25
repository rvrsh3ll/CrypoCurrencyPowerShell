function Mine-BestCoin {
    <#
    .SYNOPSIS
        Mine coins based on whattomine.com JSON api
        https://github.com/rvrsh3ll/CrypoCurrencyPowerShell/blob/master/Mine-MostProfitableCoin.ps1
        Author: Steve Borosh (@rvrsh3ll)        
        License: BSD 3-Clause
        Required Dependencies: None
        Optional Dependencies: None
    .DESCRIPTION
        Starts miners and checks ever x minutes for best coin to mine
    .PARAMETER Category
        Mine based on a specific category from whattomine.com json
    .PARAMETER CheckinInterval
        Amount of seconds between checks against whattomine.com
    .PARAMETER Coin
        Mine a specific coin
    .EXAMPLE
        Import-Module .\Mine-BestCoin.ps1
        Mine-BestCoin -Category EstimatedRewards
        or
        Mine-BestCoin -Category Profitability -Coin XMR -CheckinInterval 600
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateSet("EstimatedRewards","Profitability")]
        [String]
        $Category = "EstimatedRewards",
        [Parameter(Mandatory = $false, Position = 1)]
        [int]
        $CheckinInterval = 1800,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateSet("Electroneum","Monero","MonaCoin","VergeCoin")]
        [String]
        $Coin
    )

    # Modify to your appropriate information
    $CCMINER = "C:\Users\mining\Desktop\Active_Miners\ccminer\ccminer-x64"
    $ZECMINER = "C:\Users\mining\Desktop\Active_Miners\Zec.miner.0.3.4b\start.bat"


    $ElectroneumMiner = $CCMINER
    $ElectroneumAddress = "etnjzuULyMyJT734eWbadySxX6sdUrL15LAm4frfYBooFTMs8KqCtJC7z21vvj7gfn37vfy3k5Af5hehJx1HRVSc2upGbGnPt9"
    $ElectroneumWorkerName = "worker"
    $ElectroneumPassword = "x"
    $ElectroneumPool = "etn.dedpool.io"
    [int]$ElectroneumPoolPort = 7777

    $MoneroMiner = $CCMINER
    $MoneroAddress = "41pedfeon2jDBN3jZ2bx17HMwtoXeG3WjVrgjL69uBwzRTYTHYG4W9YiBqgDQ4ru8AiC8pvz8c7MnTqZSKSrSoLa9pDKubZ"
    $MoneroWorkerName = "worker"
    $MoneroPassword = "x"
    $MoneroPool = "xmr.dedpool.io"
    [int]$MoneroPoolPort = 7777
    
<#--
    $BitcoinGoldMiner = $CCMINER
    $BitcoinGoldAddress = "rvrsh3ll"
    $BitcoinGoldWorkerName = "worker"
    $BitcoinGoldPassword = "x"
    $BitcoinGoldPool = "us-east.equihash-hub.miningpoolhub.com"
    [int]$BitcoinGoldPoolPort = 20595
--#>
<#--
    $MonaCoinMiner = $CCMINER
    $MonaCoinAddress = "MTrY1yMtSSPo62ZbSpJFbcoxy7gZE7PFbg"
    $MonaCoinWorkerName = "worker"
    $MonaCoinPassword = "x"
    $MonaPool = "mona.poolmining.org"
    [int]$MonaPoolPort = 3093
--#>

<#--
    $VertCoinMiner = $CCMINER
    $VertCoinAddress = "VpKdGZo8n6sQXwXiTySrFU7jdaqEdiiYEK"
    $VertCoinWorkerName = "worker"
    $VertCoinPassword = "x"
    $VertCoinPool = "hub.miningpoolhub.com"
    [int]$VertPoolPort = 20507
--#>

    $ZCASHCoinMiner = $CCMINER
    $ZCASHCoinAddress = "james_rain6"
    $ZCASHCoinWorkerName = "worker"
    $ZCASHCoinPassword = "x"
    $ZCASHCoinPool = "us-east.equihash-hub.miningpoolhub.com"
    [int]$ZCASHCoinPoolPort = 20570


    $VergeCoinMiner = $CCMINER
    $VergeCoinAddress = "james_rain6"
    $VergeCoinWorkerName = "worker"
    $VergeCoinPassword = "x"
    $VergeCoinPool = "hub.miningpoolhub.com"
    [int]$VergeCoinPoolPort = 20523

      
    
    
    ###########################################################################################################################################
      
    function Start-RewardsCheck {
        # Get API JSON and convert it
        $request = Invoke-WebRequest -Uri 'https://whattomine.com/coins.json' | ConvertFrom-Json
        ### Select the coins we are mining and their current profitability. Comment or remove coins not being mined
        $Electroneum = $request.coins.Electroneum.estimated_rewards
        $Monero = $request.coins.Monero.estimated_rewards
        $ZCASH = $request.coins.Zcash.estimated_rewards
        
        ## Modify this if you change what coins you want to mine ##
        $CoinsToMine = @{Electroneum=$Electroneum;Monero=$Monero;ZCASH=$ZCASH}
        ####
        
        $MostRewardedCoin = $CoinsToMine.GetEnumerator() | Sort-Object -Property Value -Descending| Select -First 1 -ExpandProperty Name
        $MostRewardedCoin

    }


    function Start-ProfitabilityCheck {
        $request = Invoke-WebRequest -Uri 'https://whattomine.com/coins.json' | ConvertFrom-Json
        ### Select the coins we are mining and their current profitability. Comment or remove coins not being mined
        $Electroneum = $request.coins.Electroneum.profitability
        $Monero = $request.coins.Monero.profitability
        $ZCASH = $request.coins.ZCASH.profitability
        
        ## Modify this if you change what coins you want to mine ##
        $CoinsToMine = @{Electroneum=$Electroneum;Monero=$Monero;ZCASH=$ZCASH}
        ####
        
        $MostProfitableCoin = $CoinsToMine.GetEnumerator() | Sort-Object -Property Value -Descending | Select -First 1 -ExpandProperty Name
        $MostProfitableCoin
        
    }
    ######## Mining Block

    function Mine-Electroneum ($CheckinInterval) {
        Start-Process $ElectroneumMiner -ArgumentList "-a cryptonight -o stratum+tcp://$ElectroneumPool`:$ElectroneumPoolPort -u $ElectroneumAddress -p $ElectroneumPassword --cpu-priority=3"
    }
    function Mine-Monero ($CheckinInterval) {
        Start-Process $MoneroMiner -ArgumentList "-a cryptonight -o stratum+tcp://$MoneroPool`:$MoneroPoolPort -u $MoneroAddress.$MoneroWorkerName -p $MoneroPassword --cpu-priority=3"  
    }
    function Mine-VergeCoin ($CheckinInterval) {
        Start-Process $VergeCoinMiner -ArgumentList "-a scrypt -o stratum+tcp://$VergeCoinPool`:$VergeCoinPoolPort -u $VergeCoinAddress.$VergeCoinWorkerName  -p $VergeCoinPassword --cpu-priority=3"
    }
    function Mine-ZCASH ($CheckinInterval) {
        Start-Process $ZCASHCoinMiner
    }


    function Mine-Profitability ($CheckinInterval) {
        $MostProfitableCoin = Start-ProfitabilityCheck
        if ($MostProfitableCoin -eq "Electroneum") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-Electroneum
            $NewResult = $MostProfitableCoin
            While ($MostProfitableCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking Profitability.."
                $NewResult = Start-ProfitabilityCheck
                Write-Output "$NewResult is most profitable currently."
                if ($NewResult -ne $MostProfitableCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    $('Mine-') + $NewResult             
                } 
            }
        } elseif ($MostProfitableCoin -eq "Monero") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-Monero
            $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    Write-Output "$NewResult is most profitable currently."
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64"
                        $('Mine-') + $NewResult  
                                        
                    } 
                } 
        } elseif ($MostProfitableCoin -eq "ZCASH") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-ZCASH
            $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    Write-Output "$NewResult is most profitable currently."
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "miner"
                        $('Mine-') + $NewResult               
                    } 
                }
            }
        }
    function Mine-Rewards ($CheckinInterval) {
        $MostRewardedCoin = Start-RewardsCheck
        Write-Output $MostRewardedCoin
        if ($MostRewardedCoin -eq "Electroneum") {
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-Electroneum
            $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                      $('Mine-') + $NewResult              
                } 
            }
        } elseif ($MostRewardedCoin -eq "Monero") {
            Write-Output "The most rewardable coin is currently $MostRewardedCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-Monero
            $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    $('Mine-') + $NewResult  
                                    
                } 
            }
        } elseif ($MostRewardedCoin -eq "ZCASH") {
            Write-Output "The most rewardable coin is currently $MostRewardedCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-ZCASH
            $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                     $('Mine-') + $NewResult             
                } 
            }
        }elseif ($MostRewardedCoin -eq "VergeCoin") {
            Write-Output "The most rewardable coin is currently $MostRewardedCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-VergeCoin
                $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    $('Mine-') + $NewResult               
                } 
            }          
        }
    } 
    # Check if we are mining solo
    if ($Coin) {
        Write-Output "Mining $Coin.."
        $CointoMine = $('Mine-') + $Coin
        .$CointoMine
    }else {
        if ($Category -eq "Profitability") {
            Mine-Profitability $CheckinInterval  
        } elseif ($Category -eq "EstimatedRewards") {
            Mine-Rewards $CheckinInterval
        }
    }  
}
