$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
Import-Module "$ScriptDir/../../PoshArmDeployment" -Force

InModuleScope PoshArmDeployment {
    Describe "Remove-ExtraBracketInArmTemplateFunction" {
        It "Given an object with properties containing nested Arm Template function then cleans up the extra brackets" -TestCases @(
            @{ InputObject = [PSCustomObject]@{
                    NotAnArmTemplateFunction = "value"
                }; Expected= [PSCustomObject]@{
                    NotAnArmTemplateFunction = "value"
                };
            }
            @{ InputObject = [PSCustomObject]@{
                    ArmTemplateFunction = "[value]"
                }; Expected= [PSCustomObject]@{
                    ArmTemplateFunction = "[value]"
                };
            }
            @{ InputObject = [PSCustomObject]@{
                    ArmTemplateFunction = "[concat(value, [anotherFunction()])]"
                }; Expected= [PSCustomObject]@{
                    ArmTemplateFunction = "[concat(value, anotherFunction())]"
                };
            }
            @{InputObject = [PSCustomObject]@{
                    innerObect = [PSCustomObject]@{
                        ArmTemplateFunction = "[concat(value, [anotherFunction()])]"
                    }
                }; Expected= [PSCustomObject]@{
                    innerObect = [PSCustomObject]@{
                        ArmTemplateFunction = "[concat(value, anotherFunction())]"
                    }
                };
            }
        ) {
            param($InputObject, $Expected)

            $actual = $InputObject | Remove-ExtraBracketInArmTemplateFunction

            ($actual | ConvertTo-Json -Compress) | Should -Be ($Expected | ConvertTo-Json -Compress)
        }
    }
}