<#
 .DESCRIPTION
    Creates Azure BluePrint

 .NOTES
    Author: Neil Peterson
    Intent: Sample to demonstrate Azure BluePrints with Azure DevOps
 #>

 param (
    [string]$SubscriptionId,
    [string]$ManagementGroup,
    [string]$BlueprintName,
    [string]$BlueprintAssignmentPath,
    [bool]$Wait
)

$BluePrintObject = Get-AzBlueprint -Name $BlueprintName -ManagementGroupId $ManagementGroup

# Add Blueprint ID
$body = Get-Content -Raw -Path $BlueprintAssignmentPath | ConvertFrom-Json
$body.properties.blueprintId = $BluePrintObject.id
$body | ConvertTo-Json -Depth 4 | Out-File -FilePath $BlueprintAssignmentPath -Encoding utf8 -Force

New-AzBlueprintAssignment -Name "storage-blueprint-fail" -Blueprint $BluePrintObject -AssignmentFile $BlueprintAssignmentPath -SubscriptionId $SubscriptionId

if ($Wait -eq "true") {
   $timeout = new-timespan -Seconds 240
   $sw = [diagnostics.stopwatch]::StartNew()

   while (($sw.elapsed -lt $timeout) -or ($AssignemntStatus.ProvisioningState -eq "Succeeded")) {
         $AssignemntStatus = Get-AzBlueprintAssignment -Name 'storage-blueprint-fail' -SubscriptionId $SubscriptionId
         write-output $AssignemntStatus.ProvisioningState
         if ($AssignemntStatus.ProvisioningState -eq "failed") {
            Write-Error "Issue"
            break
         }
         Sleep 5
   }
   $AssignemntStatus = Get-AzBlueprintAssignment -Name 'storage-blueprint-fail' -SubscriptionId $SubscriptionId
}