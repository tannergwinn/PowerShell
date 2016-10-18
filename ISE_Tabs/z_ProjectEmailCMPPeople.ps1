#Email some people

$emailcsv = import-csv C:\ScriptSources\CMP_WayPoint.csv

foreach($address in $emailcsv)
{
                $email = $address.email
                echo "$email"
                $url = "http://portal.colonyamerican.com/Account/Forgot"
                $ie = New-Object -comobject InternetExplorer.Application 
                $ie.visible = $true 
                $ie.silent = $true 
                while( $ie.busy){Start-Sleep 1} 
                $ie.Navigate( $url )
                while( $ie.busy){Start-Sleep 1} 
                $IE.Document.getElementById("email").value = $email
                Sleep 2
                $link=$ie.Document.getElementsByTagName(“button”) | where-object {$_.type -eq "submit"}
                $link.click()
                sleep 2
                while( $ie.busy){Start-Sleep 1} 
                sleep 2
                $ie.Quit()
}

