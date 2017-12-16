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
        Mine based on a specific category

    .EXAMPLE
        Import-Module .\Mine-BestCoin.ps1
        Mine-BestCoin -Category EstimatedRewards
        or
        Mine-BestCoin -Category Profitability
    #>

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet("EstimatedRewards","Profitability")]
        [String]
        $Category = "EstimatedRewards"
    )

    # Modify to your appropriate information

    $ElectroneumMiner = "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.2-cuda9\ccminer-x64.exe"
    $ElectroneumAddress = "etnkL9RRWWXaA1am6ZGsCvERaytZGPmLXi7jruxiQuXP4pLYYhkG3PXKczkheD3j1YPchvRGvpe7ySgRw77QqXjV8WV2QZsJM9"
    $ElectroneumWorkerName = "myrig"
    $ElectroneumPassword = "x"
    $ElectroneumPool = "etn.dedpool.io"
    [int]$ElectroneumPoolPort = 5555

    $MoneroMiner = "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.2-cuda9\ccminer-x64.exe"
    $MoneroAddress = "4ALcw9nTAStZSshoWVUJakZ6tLwTDhixhQUQNJkCn4t3fG3MMK19WZM44HnQRvjqmz4LkkA8t565v7iBwQXx2r34HNroSAZ"
    $MoneroWorkerName = "myrig"
    $MoneroPassword = "x"
    $MoneroPool = "xmr.dedpool.io"
    [int]$MoneroPoolPort = 5555
    

    $BitcoinGoldMiner = "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.2-cuda9\ccminer-x64.exe"
    $BitcoinGoldAddress = "rvrsh3ll"
    $BitcoinGoldWorkerName = "rvrsh3llbtg1"
    $BitcoinGoldPassword = "btg1"
    $BitcoinGoldPool = "us-east.equihash-hub.miningpoolhub.com"
    [int]$BitcoinGoldPoolPort = 20595
    

    $MonaCoinMiner = "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.2-cuda9\ccminer-x64.exe"
    $MonaCoinAddress = "MTrY1yMtSSPo62ZbSpJFbcoxy7gZE7PFbg"
    $MonaCoinWorkerName = "myrig"
    $MonaCoinPassword = "x"
    $MonaPool = "mona.poolmining.org"
    [int]$MonaPoolPort = 3093


    $VertCoinMiner = "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.2-cuda9\ccminer-x64.exe"
    $VertCoinAddress = "VpKdGZo8n6sQXwXiTySrFU7jdaqEdiiYEK"
    $VertCoinWorkerName = "rvrsh3ll"
    $VertCoinPassword = "rvrsh3llvert1"
    $VertCoinPool = "vtc.poolmining.org"
    [int]$VertPoolPort = 3096

    # How often in seconds to check whattomine.com
    [int]$CheckinInterval = 1800
    
    
    ###########################################################################################################################################
    
    
    
    function Start-RewardsCheck {
        $request = ""
        # Get API JSON and convert it
        $request = Invoke-WebRequest -Uri 'https://whattomine.com/coins.json' | ConvertFrom-Json
        ### Select the coins we are mining and their current profitability. Comment or remove coins not being mined
        $Electroneum = $request.coins.Electroneum.estimated_reward
        $Monero = $request.coins.Monero.estimated_reward
        $BitCoinGold = $request.coins.BitcoinGold.estimated_reward
        $MonaCoin = $request.coins.MonaCoin.estimated_reward
        $VertCoin = $request.coins.VertCoin.estimated_reward
        $CoinsToMine = @{Electroneum=$Electroneum;Monero=$Monero;BitcoinGold=$BitCoinGold;MonaCoin=$MonaCoin;VertCoin=$VertCoin}

        
        ### Modify Variable to match the coins you are mining
        $MostRewardedCoin = Get-Variable -Name BitCoinGold,Electroneum,Monero,MonaCoin,VertCoin | Sort-Object -Property Value | Select -Last 1 -ExpandProperty Name
        $MostRewardedCoin

    }


    function Start-ProfitabilityCheck {
        # Get API JSON and convert it
        $request = ""
        $request = Invoke-WebRequest -Uri 'https://whattomine.com/coins.json' | ConvertFrom-Json




        ### Select the coins we are mining and their current profitability. Comment or remove coins not being mined
        $Electroneum = $request.coins.Electroneum.profitability
        $Monero = $request.coins.Monero.profitability
        $BitCoinGold = $request.coins.BitcoinGold.profitability
        $MonaCoin = $request.coins.MonaCoin.profitability
        $VertCoin = $request.coins.VertCoin.profitability
        $CoinsToMine = @{Electroneum=$Electroneum;Monero=$Monero;BitcoinGold=$BitCoinGold;MonaCoin=$MonaCoin;VertCoin=$VertCoin}

        
        ### Modify Variable to match the coins you are mining
        $MostProfitableCoin = Get-Variable -Name BitCoinGold,Electroneum,Monero,MonaCoin,VertCoin | Sort-Object -Property Value | Select -Last 1 -ExpandProperty Name
        $MostProfitableCoin
    }

    function Start-Mining ($Category) {
        
        if ($Category -eq "Profitability") {
            $MostProfitableCoin = Start-ProfitabilityCheck
            Write-Output $MostProfitableCoin
            if ($MostProfitableCoin -eq "Electroneum") {
                Write-Output "The most profitable coin is currently $MostProfitableCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostProfitableCoin..."
                Start-Process $ElectroneumMiner -ArgumentList "-a cryptonight -o stratum+tcp://$ElectroneumPool`:$ElectroneumPoolPort.$ElectroneumWorkerName -u $ElectroneumAddress -p $ElectroneumPassword --cpu-priority=3"
                $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64.exe"
                        break              
                    } 
                }
            } elseif ($MostProfitableCoin -eq "Monero") {
                Write-Output "The most profitable coin is currently $MostProfitableCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostProfitableCoin..."
                Start-Process $MoneroMiner -ArgumentList "-a cryptonight -o stratum+tcp://$MoneroPool`:$MoneroPoolPort -u $MoneroAddress.$MoneroWorkerName -p $MoneroPassword --cpu-priority=3"
                $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64.exe"
                        break
                                        
                    } 
                }
            } elseif ($MostProfitableCoin -eq "BitCoinGold") {
                Write-Output "The most profitable coin is currently $MostProfitableCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostProfitableCoin..."
                Start-Process $BitCoinGoldMiner -ArgumentList "-a equihash -o stratum+tcp://$BitcoinGoldPool`:$BitcoinGoldPoolPort -u $BitCoinGoldAddress.$BitcoinGoldWorkerName -p $BitcoinGoldPassword --cpu-priority=3"
                $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64.exe" 
                        break            
                    } 
                }
            } elseif ($MostProfitableCoin -eq "MonaCoin") {
                Write-Output "The most profitable coin is currently $MostProfitableCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostProfitableCoin..."
                Start-Process $BitCoinGoldMiner -ArgumentList "-a lyra2v2 -o stratum+tcp://$MonaPool`:$MonaPoolPort -u $MonaCoinAddress.$MonaCoinWorkerName  -p $MonaCoinPassword --cpu-priority=3"
                $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64.exe"
                        break             
                    } 
                }
            }elseif ($MostProfitableCoin -eq "VertCoin") {
                Write-Output "The most profitable coin is currently $MostProfitableCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostProfitableCoin..."
                Start-Process $VertCoinMiner -ArgumentList "-a lyra2v2 -o stratum+tcp://$VertCoinPool`:$VertPoolPort -u $VertCoinAddress.$VertCoinWorkerName  -p $VertCoinPassword --cpu-priority=3"
                $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64.exe"
                        break             
                    } 
                }
            }
        } elseif ($Category -eq "EstimatedRewards")  {

            $MostRewardedCoin = Start-RewardsCheck
            Write-Output $$MostRewardedCoin
            if ($MostRewardedCoin -eq "Electroneum") {
                Write-Output "The most profitable coin is currently $MostRewardedCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostRewardedCoin..."
                Start-Process $ElectroneumMiner -ArgumentList "-a cryptonight -o stratum+tcp://$ElectroneumPool`:$ElectroneumPoolPort.$ElectroneumWorkerName -u $ElectroneumAddress -p $ElectroneumPassword --cpu-priority=3"
                $NewResult = $MostRewardedCoin
                While ($MostRewardedCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-RewardsCheck
                    if ($NewResult -ne $MostRewardedCoin) {
                        Stop-Process -Processname "ccminer-x64.exe"
                        break              
                    } 
                }
            } elseif ($MostRewardedCoin -eq "Monero") {
                Write-Output "The most profitable coin is currently $MostRewardedCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostRewardedCoin..."
                Start-Process $MoneroMiner -ArgumentList "-a cryptonight -o stratum+tcp://$MoneroPool`:$MoneroPoolPort -u $MoneroAddress.$MoneroWorkerName -p $MoneroPassword --cpu-priority=3"
                $NewResult = $MostRewardedCoin
                While ($MostRewardedCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-RewardsCheck
                    if ($NewResult -ne $MostRewardedCoin) {
                        Stop-Process -Processname "ccminer-x64.exe"
                        break
                                        
                    } 
                }
            } elseif ($MostRewardedCoin -eq "BitCoinGold") {
                Write-Output "The most profitable coin is currently $MostRewardedCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostRewardedCoin..."
                Start-Process $BitCoinGoldMiner -ArgumentList "-a equihash -o stratum+tcp://$BitcoinGoldPool`:$BitcoinGoldPoolPort -u $BitCoinGoldAddress.$BitcoinGoldWorkerName -p $BitcoinGoldPassword --cpu-priority=3"
                $NewResult = $MostRewardedCoin
                While ($MostRewardedCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-RewardsCheck
                    if ($NewResult -ne $MostRewardedCoin) {
                        Stop-Process -Processname "ccminer-x64.exe" 
                        break            
                    } 
                }
            } elseif ($MostRewardedCoinn -eq "MonaCoin") {
                Write-Output "The most profitable coin is currently $MostRewardedCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostRewardedCoin..."
                Start-Process $BitCoinGoldMiner -ArgumentList "-a lyra2v2 -o stratum+tcp://$MonaPool`:$MonaPoolPort -u $MonaCoinAddress.$MonaCoinWorkerName  -p $MonaCoinPassword --cpu-priority=3"
                $NewResult = $MostRewardedCoin
                While ($MostRewardedCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-RewardsCheck
                    if ($NewResult -ne $MostRewardedCoin) {
                        Stop-Process -Processname "ccminer-x64.exe"
                        break             
                    } 
                }
            }elseif ($MostRewardedCoin -eq "VertCoin") {
                Write-Output "The most profitable coin is currently $MostRewardedCoin"
                Write-Output " "
                Write-Output "Beginning to mine $MostRewardedCoin..."
                Start-Process $VertCoinMiner -ArgumentList "-a lyra2v2 -o stratum+tcp://$VertCoinPool`:$VertPoolPort -u $VertCoinAddress. $VertCoinWorkerName  -p $VertCoinPassword --cpu-priority=3"
                $NewResult = $MostRewardedCoin
                While ($MostRewardedCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-RewardsCheck
                    if ($NewResult -ne $MostRewardedCoin) {
                        Stop-Process -Processname "ccminer-x64.exe"
                        break             
                    } 
                }
            }
        }          
    } Start-Mining -Category $Category
}







