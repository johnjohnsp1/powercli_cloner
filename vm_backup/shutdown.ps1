add-pssnapin VMware.VimAutomation.Core

Connect-VIServer vcenter

$offsite = Get-VMHost 192.168.1.239

if($offsite) {
    $offsite_fileserver = Get-VM -Name "Offsite File Server" 
    while($offsite_fileserver.powerstate -eq "PoweredOn") {
        write-output "Waiting for offsite fileserver to shut down."
        Start-Sleep -s 10
        $offsite_fileserver = Get-VM -Name "Offsite File Server" 
    }
    $offsite | %{Get-View $_.ID} | %{$_.ShutdownHost_Task($TRUE)}
}