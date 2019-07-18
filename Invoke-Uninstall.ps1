function Invoke-Uninstall ($productName) {
    $uninstall32 = Get-ChildItem "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_.DisplayName -eq $productName } | select UninstallString
    $uninstall64 = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_.DisplayName -eq $productName } | select UninstallString

    if ($uninstall64) {
        $cmd = "& $($uninstall64.UninstallString) /quiet"
    }
    if ($uninstall32) {
        $cmd = "$($uninstall32.UninstallString) /quiet" -Replace "MsiExec.exe ", ""
    }
    $process = Start-Process MsiExec.exe "$cmd" -Wait -PassThru -WindowStyle Hidden        
}
