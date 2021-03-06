add-pssnapin VMware.VimAutomation.Core

Connect-VIServer vcenter

$offsite = Get-VMHost 192.168.1.239

if($offsite) {
    $offsite_fileserver = Get-VM -Name "fsoffsite" 
    while($offsite_fileserver.powerstate -eq "PoweredOn") {
        write-output "Waiting for offsite fileserver to shut down."
        Start-Sleep -s 60
        $offsite_fileserver = Get-VM -Name "fsoffsite" 
    }
    $offsite | %{Get-View $_.ID} | %{$_.ShutdownHost_Task($TRUE)}
}

#Because the local vSphere server can sometimes 
#stop reading the state of hosts properly
#a restart after each backup inreases chances of
# a successful backup
Restart-Computer