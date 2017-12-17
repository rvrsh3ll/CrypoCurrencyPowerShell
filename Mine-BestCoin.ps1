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
        [ValidateSet("Electroneum","Monero","BitcoinGold","MonaCoin","VertCoin")]
        [String]
        $Coin
    )

    # Modify to your appropriate information
    $CCMINER = "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.2-cuda9\ccminer-x64"

    $ElectroneumMiner = $CCMINER
    $ElectroneumAddress = "etnkL9RRWWXaA1am6ZGsCvERaytZGPmLXi7jruxiQuXP4pLYYhkG3PXKczkheD3j1YPchvRGvpe7ySgRw77QqXjV8WV2QZsJM9"
    $ElectroneumWorkerName = "myrig"
    $ElectroneumPassword = "x"
    $ElectroneumPool = "etn.dedpool.io"
    [int]$ElectroneumPoolPort = 5555

    $MoneroMiner = $CCMINER
    $MoneroAddress = "4ALcw9nTAStZSshoWVUJakZ6tLwTDhixhQUQNJkCn4t3fG3MMK19WZM44HnQRvjqmz4LkkA8t565v7iBwQXx2r34HNroSAZ"
    $MoneroWorkerName = "myrig"
    $MoneroPassword = "x"
    $MoneroPool = "xmr.dedpool.io"
    [int]$MoneroPoolPort = 5555
    

    $BitcoinGoldMiner = $CCMINER
    $BitcoinGoldAddress = "rvrsh3ll"
    $BitcoinGoldWorkerName = "rvrsh3llbtg1"
    $BitcoinGoldPassword = "btg1"
    $BitcoinGoldPool = "us-east.equihash-hub.miningpoolhub.com"
    [int]$BitcoinGoldPoolPort = 20595
    

    $MonaCoinMiner = $CCMINER
    $MonaCoinAddress = "MTrY1yMtSSPo62ZbSpJFbcoxy7gZE7PFbg"
    $MonaCoinWorkerName = "myrig"
    $MonaCoinPassword = "x"
    $MonaPool = "mona.poolmining.org"
    [int]$MonaPoolPort = 3093


    $VertCoinMiner = $CCMINER
    $VertCoinAddress = "VpKdGZo8n6sQXwXiTySrFU7jdaqEdiiYEK"
    $VertCoinWorkerName = "rvrsh3ll"
    $VertCoinPassword = "rvrsh3llvert1"
    $VertCoinPool = "hub.miningpoolhub.com"
    [int]$VertPoolPort = 2057

        
    
    
    ###########################################################################################################################################
      
    function Start-RewardsCheck {
        # Get API JSON and convert it
        $request = Invoke-WebRequest -Uri 'https://whattomine.com/coins.json' | ConvertFrom-Json
        ### Select the coins we are mining and their current profitability. Comment or remove coins not being mined
        $Electroneum = $request.coins.Electroneum.estimated_rewards
        $Monero = $request.coins.Monero.estimated_rewards
        $BitCoinGold = $request.coins.BitcoinGold.estimated_rewards
        $MonaCoin = $request.coins.MonaCoin.estimated_rewards
        $VertCoin = $request.coins.VertCoin.estimated_rewards
        $CoinsToMine = @{Electroneum=$Electroneum;Monero=$Monero;BitcoinGold=$BitCoinGold;MonaCoin=$MonaCoin;VertCoin=$VertCoin}
        ### Modify Variable to match the coins you are mining
        $MostRewardedCoin = $CoinsToMine.GetEnumerator() | Sort-Object -Property Value -Descending | Select -First 1 -ExpandProperty Name
        $MostRewardedCoin

    }


    function Start-ProfitabilityCheck {
        $request = Invoke-WebRequest -Uri 'https://whattomine.com/coins.json' | ConvertFrom-Json
        ### Select the coins we are mining and their current profitability. Comment or remove coins not being mined
        $Electroneum = $request.coins.Electroneum.profitability
        $Monero = $request.coins.Monero.profitability
        $BitCoinGold = $request.coins.BitcoinGold.profitability
        $MonaCoin = $request.coins.MonaCoin.profitability
        $VertCoin = $request.coins.VertCoin.profitability
        $CoinsToMine = @{Electroneum=$Electroneum;Monero=$Monero;BitcoinGold=$BitCoinGold;MonaCoin=$MonaCoin;VertCoin=$VertCoin}

        ### Modify Variable to match the coins you are mining
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
    function Mine-BitcoinGold ($CheckinInterval) {
        Start-Process $BitCoinGoldMiner -ArgumentList "-a equihash -o stratum+tcp://$BitcoinGoldPool`:$BitcoinGoldPoolPort -u $BitCoinGoldAddress.$BitcoinGoldWorkerName -p $BitcoinGoldPassword --cpu-priority=3"
    }
    function Mine-MonaCoin ($CheckinInterval) {
        Start-Process $BitCoinGoldMiner -ArgumentList "-a lyra2v2 -o stratum+tcp://$MonaPool`:$MonaPoolPort -u $MonaCoinAddress.$MonaCoinWorkerName  -p $MonaCoinPassword --cpu-priority=3"
    }
    function Mine-VertCoin ($CheckinInterval) {
        Start-Process $VertCoinMiner -ArgumentList "-a lyra2v2 -o stratum+tcp://$VertCoinPool`:$VertPoolPort -u $VertCoinAddress.$VertCoinWorkerName  -p $VertCoinPassword --cpu-priority=3"
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
                    break              
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
                        break
                                        
                    } 
                }
        } elseif ($MostProfitableCoin -eq "BitCoinGold") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-BitcoinGold
            $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    Write-Output "$NewResult is most profitable currently."
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64" 
                        break            
                    } 
                }
        } elseif ($MostProfitableCoin -eq "MonaCoin") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-MonaCoin
            $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    Write-Output "$NewResult is most profitable currently."
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64"
                        break             
                    } 
                }
        } elseif ($MostProfitableCoin -eq "VertCoin") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-VertCoin
            $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    Write-Output "$NewResult is most profitable currently."
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64"
                        break             
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
                    break              
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
                    break
                                    
                } 
            }
        } elseif ($MostRewardedCoin -eq "BitCoinGold") {
            Write-Output "The most rewardable coin is currently $MostRewardedCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-BitCoinGold
            $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64" 
                    break            
                } 
            }
        } elseif ($MostRewardedCoinn -eq "MonaCoin") {
            Write-Output "The most rewardable coin is currently $MostRewardedCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-MonaCoin
            $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    break             
                } 
            }
        }elseif ($MostRewardedCoin -eq "VertCoin") {
            Write-Output "The most rewardable coin is currently $MostRewardedCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-VertCoin
                $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    break             
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

