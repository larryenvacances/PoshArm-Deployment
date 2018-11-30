function Add-ArmNic {
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "vm")]
    Param(
        [PSTypeName("VirtualMachine")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "vm")]
        $VirtualMachine,
        [PSTypeName("VirtualMachineScaleSet")]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "vmss")]
        $VirtualMachineScaleSet,
        [PSTypeName("Nic")]
        [Parameter(Mandatory)]
        $Nic,
        [string]
        $Name = "default"
    )

    Process {
        If ($PSCmdlet.ShouldProcess("Adding network interface configuration to a virtual machine")) {

            if ($PSCmdlet.ParameterSetName -eq "vm") {
                $VirtualMachine.properties.networkProfile.networkInterfaceConfigurations += $Nic
                return $VirtualMachine
            }
            else {
                $VirtualMachineScaleSet.properties.virtualMachineProfile.networkProfile.networkInterfaceConfigurations += $Nic
                return $VirtualMachineScaleSet
            }
        }
    }
}