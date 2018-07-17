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
        [ValidateSet("BitSend","Digibyte","Verge","RavenCoin","HelpTheHomeless")]
        [String]
        $Coin
    )

    
    
    
    ###########################################################################################################################################
      
    function Start-RewardsCheck {
        # Get API JSON and convert it
        $request = Invoke-WebRequest -Uri 'https://whattomine.com/coins.json' | ConvertFrom-Json
        ## Modify to select the coins we are mining and their current profitability. Comment or remove coins not being mined
        $BitSend = $request.coins.BitSend.estimated_rewards
        $DigiByte = $request.coins.DigiByte.estimated_rewards
        $RavenCoin = $request.coins.RavenCoin.estimated_rewards
        $VERGE = $request.coins.Verge.estimated_rewards
        $HelpTheHomeless = $request.coins.HelpTheHomeless.estimated_rewards
        
        ## Modify this if you change what coins you want to mine ##
        $CoinsToMine = @{BitSend=$BitSend;RavenCoin=$RavenCoin;VERGE=$VERGE;HelpTheHomeless=$HelpTheHomeless;DigiByte=$DigiByte}
        ####
        
        $MostRewardedCoin = $CoinsToMine.GetEnumerator() | Sort-Object -Property Value -Descending| Select -First 1 -ExpandProperty Name
        $MostRewardedCoin

    }


    function Start-ProfitabilityCheck {
        $request = Invoke-WebRequest -Uri 'https://whattomine.com/coins.json' | ConvertFrom-Json
        ## Modify to select the coins we are mining and their current profitability. Comment or remove coins not being mined
        $BitSend = $request.coins.BitSend.profitability
        $DigiByte = $request.coins.DigiByte.profitability
        $RavenCoin = $request.coins.RavenCoin.profitability
        $VERGE = $request.coins.Verge.profitability
        $HelpTheHomeless = $request.coins.HelpTheHomeless.profitability
        
        ## Modify this if you change what coins you want to mine ##
        $CoinsToMine = @{BitSend=$BitSend;RavenCoin=$RavenCoin;VERGE=$VERGE;HelpTheHomeless=$HelpTheHomeless;DigiByte=$DigiByte}
        ####
        
        $MostProfitableCoin = $CoinsToMine.GetEnumerator() | Sort-Object -Property Value -Descending | Select -First 1 -ExpandProperty Name
        $MostProfitableCoin
        
    }
    ######## Mining Block: Point to your appropriate miners

    function Mine-BitSend ($CheckinInterval) {
        Start-Process -FilePath "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer_bitsend\ccminer.exe" -ArgumentList "-a xevan -u i78BgEXTkisLWXYcWSUANcfeAbQp7zBHAM.rig1 -p x --cpu-priority=3 -o stratum+tcp://omegapool.cc:8005"
    }
    function Mine-VergeCoin ($CheckinInterval) {
        Start-Process -FilePath "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.5-cuda9\ccminer-x64.exe" -ArgumentList "-a blake2s -o stratum+tcp://xvg.antminepool.com:9008 -u RFQXKVKpHMwyJ86YqQUJSZK1S8m8oRbC5h -p x --cpu-priority=3"
    }
    function Mine-RavenCoin ($CheckinInterval) {
        Start-Process -FilePath "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.5-cuda9\ccminer-x64.exe" -ArgumentList "-a x16r -o stratum+tcp://rvn-us.coinblockers.com:4449 -u RFQXKVKpHMwyJ86YqQUJSZK1S8m8oRbC5h -p x --cpu-priority=3"
    }
    function Mine-HelpTheHomeless ($CheckinInterval) {
        Start-Process -FilePath "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.5-cuda9\ccminer-x64.exe" -ArgumentList "-a x16r -o stratum+tcp://gpuhot.com:36361 -u HHS7W41529y14wy9rR4NRsCjD56Va4bPYp -p c=HTH --cpu-priority=3"
    }
    function Mine-DigiByte ($CheckinInterval) {
        Start-Process -FilePath "C:\Users\rvrsh3ll\Desktop\mining\Active_Miners\ccminer-x64-2.2.5-cuda9\ccminer-x64.exe" -ArgumentList "--algo=myr-gr -o stratum+tcp://stratum.dgb-groestl.theblocksfactory.com:9003 -u user.rig -p password"
    }
   



    function Mine-Profitability ($CheckinInterval) {
        $MostProfitableCoin = Start-ProfitabilityCheck
        if ($MostProfitableCoin -eq "BitSend") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-BitSend
            $NewResult = $MostProfitableCoin
            While ($MostProfitableCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking Profitability.."
                $NewResult = Start-ProfitabilityCheck
                Write-Output "$NewResult is most profitable currently."
                if ($NewResult -ne $MostProfitableCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    Stop-Process -Processname "ccminer"
                    $("Mine-" + $NewResult)             
                } 
            }
        } elseif ($MostProfitableCoin -eq "RavenCoin") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-RavenCoin
            $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    Write-Output "$NewResult is most profitable currently."
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64"
                        Stop-Process -Processname "ccminer"
                        $("Mine-" + $NewResult)               
                    } 
                }
            }elseif ($MostProfitableCoin -eq "Verge") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-RavenCoin
            $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    Write-Output "$NewResult is most profitable currently."
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64"
                        Stop-Process -Processname "ccminer"
                        $("Mine-" + $NewResult)               
                    } 
                }
            }elseif ($MostProfitableCoin -eq "HelpTheHomeless") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-HelpTheHomeless
            $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    Write-Output "$NewResult is most profitable currently."
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64"
                        Stop-Process -Processname "ccminer"
                        $("Mine-" + $NewResult)               
                    } 
                }
            }elseif ($MostProfitableCoin -eq "DigiByte") {
            Write-Output "The most profitable coin is currently $MostProfitableCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostProfitableCoin..."
            Mine-DigiByte
            $NewResult = $MostProfitableCoin
                While ($MostProfitableCoin -eq $NewResult) {
                    Start-Sleep -Seconds $CheckinInterval
                    Write-Output "Checking Profitability.."
                    $NewResult = Start-ProfitabilityCheck
                    Write-Output "$NewResult is most profitable currently."
                    if ($NewResult -ne $MostProfitableCoin) {
                        Stop-Process -Processname "ccminer-x64"
                        Stop-Process -Processname "ccminer"
                        $("Mine-" + $NewResult)               
                    } 
                }
            }
        }
    
    function Mine-Rewards ($CheckinInterval) {
        $MostRewardedCoin = Start-RewardsCheck
        Write-Output $MostRewardedCoin
        if ($MostRewardedCoin -eq "BitSend") {
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-BitSend
            $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    Stop-Process -Processname "ccminer"
                      $("Mine-" + $NewResult)              
                } 
            }
        } elseif ($MostRewardedCoin -eq "RavenCoin") {
            Write-Output "The most rewardable coin is currently $MostRewardedCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-RavenCoin
            $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    Stop-Process -Processname "ccminer"
                     $("Mine-" + $NewResult)             
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
                    Stop-Process -Processname "ccminer"
                    $("Mine-" + $NewResult)               
                } 
            }          
        }elseif ($MostRewardedCoin -eq "HelpTheHomeless") {
            Write-Output "The most rewardable coin is currently $MostRewardedCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-HelpTheHomeless
                $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    Stop-Process -Processname "ccminer"
                    $("Mine-" + $NewResult)               
                } 
            }
        }elseif ($MostRewardedCoin -eq "DigiByte") {
            Write-Output "The most rewardable coin is currently $MostRewardedCoin"
            Write-Output " "
            Write-Output "Beginning to mine $MostRewardedCoin..."
            Mine-DigiByte
                $NewResult = $MostRewardedCoin
            While ($MostRewardedCoin -eq $NewResult) {
                Start-Sleep -Seconds $CheckinInterval
                Write-Output "Checking reward amounts.."
                $NewResult = Start-RewardsCheck
                Write-Output "$NewResult currently has the highest reward rate."
                if ($NewResult -ne $MostRewardedCoin) {
                    Stop-Process -Processname "ccminer-x64"
                    Stop-Process -Processname "ccminer"
                    $("Mine-" + $NewResult)               
                } 
            }
        }
    } 
    # Check if we are mining solo
    if ($Coin) {
        Write-Output "Mining $Coin.."
        $CointoMine = $('Mine-' + $Coin)
        .$CointoMine
    }else {
        if ($Category -eq "Profitability") {
            Mine-Profitability $CheckinInterval  
        } elseif ($Category -eq "EstimatedRewards") {
            Mine-Rewards $CheckinInterval
        }
    }  
}
