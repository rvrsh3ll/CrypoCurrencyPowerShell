function Mine-MostProfitableCoin {
  

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
    $MoneroPool = "xmr-us-east1.nanopool.org"
    [int]$MoneroPoolPort = 14444
    

    $BitcoinGoldMiner = "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.2-cuda9\ccminer-x64.exe"
    $BitcoinGoldAddress = "GZW8HNJKouHdVCWcAxCb3EXumfbN9nyW54"
    $BitcoinGoldWorkerName = "myrig"
    $BitcoinGoldPassword = "x"
    $BitcoinPool = "us-east.equihash-hub.miningpoolhub.com"
    [int]$BitcoinPoolPort = 12023
    

    $MonaCoinMiner = "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.2-cuda9\ccminer-x64.exe"
    $MonaCoinAddress = "MTrY1yMtSSPo62ZbSpJFbcoxy7gZE7PFbg"
    $MonaCoinWorkerName = "myrig"
    $MonaCoinPassword = "x"
    $MonaPool = "mona.poolmining.org"
    [int]$MonaPoolPort = 3093


    # How often in seconds to check whattomine.com
    [int]$CheckinInterval = 5
    
    
    ###########################################################################################################################################
    
    
    



    function Start-ProfitabilityCheck {
        # Get API JSON and convert it
        $request = Invoke-WebRequest -Uri 'https://whattomine.com/coins.json' | ConvertFrom-Json


        ### Select the coins we are mining and their current profitability. Comment or remove coins not being mined
        $Electroneum = $request.coins.Electroneum.profitability
        $Monero = $request.coins.Monero.profitability
        $BitCoinGold = $request.coins.BitcoinGold.profitability
        $MonaCoin = $request.coins.MonaCoin.profitability
        $CoinsToMine = @{Electroneum=$Electroneum;Monero=$Monero;BitcoinGold=$BitCoinGold;MonaCoin=$MonaCoin}

        
        ### Modify Variable to match the coins you are mining
        $MostProfitableCoin = Get-Variable -Name BitCoinGold,Electroneum,Monero,MonaCoin | Sort-Object -Property Value | Select -Last 1 -ExpandProperty Name
        $MostProfitableCoin
    }

    function Start-Mining {
  
        $MostProfitableCoin = Start-ProfitabilityCheck
        Write-Output $MostProfitableCoin
        if ($MostProfitableCoin -eq "Electroneum") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Start-Process $ElectroneumMiner -ArgumentList "-a cryptonight -o stratum+tcp://$ElectroneumPool`:$ElectroneumPoolPort -u $ElectroneumAddress -p $ElectroneumPassword --cpu-priority=3"
            $NewResult = $MostProfitableCoin
            While ($MostProfitableCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking Profitability.."
                $NewResult = Start-ProfitabilityCheck
                if ($NewResult -ne $MostProfitableCoin) 
                    Stop-Process -Processname "ccminer-x64"
                    break              
                } 
            }
        } elseif ($MostProfitableCoin -eq "Monero") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Start-Process $MoneroMiner -ArgumentList "-a cryptonight -o stratum+tcp://$MoneroPool + ":" + $MoneroPoolPort -u $MoneroAddress.$MoneroWorkerName -p $MoneroPassword --cpu-priority=3"
            $NewResult = $MostProfitableCoin
            While ($MostProfitableCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking Profitability.."
                $NewResult = Start-ProfitabilityCheck
                if ($NewResult -ne $MostProfitableCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    break
                                    
                } 
            }
        } elseif ($MostProfitableCoin -eq "BitCoinGold") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Start-Process $BitCoinGoldMiner -ArgumentList "-a equihash -o stratum+tcp://$BitcoinGoldPool + ":" + $BitcoinGoldPoolPort -u $BitCoinGoldAddress.$BitcoinGoldWorkerName -p $BitcoinGoldPassword --cpu-priority=3"
            $NewResult = $MostProfitableCoin
            While ($MostProfitableCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking Profitability.."
                $NewResult = Start-ProfitabilityCheck
                if ($NewResult -ne $MostProfitableCoin) {
                    Stop-Process -Processname "ccminer-x64" 
                    break            
                } 
            }
        } elseif ($MostProfitableCoin -eq "MonaCoin") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Start-Process $BitCoinGoldMiner -ArgumentList "-a lyra2v2 -o stratum+tcp://$Mona_Server + ":" + $MonaPoolPort -u $MonaCoin.$MonaCoinWorkerName  -p x --cpu-priority=3"
            $NewResult = $MostProfitableCoin
            While ($MostProfitableCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking Profitability.."
                $NewResult = Start-ProfitabilityCheck
                if ($NewResult -ne $MostProfitableCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    break             
                } 
            }
        }     
    } Start-Mining
}
