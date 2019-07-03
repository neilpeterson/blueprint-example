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
    [string]$BlueprintAssignmentPath
)

$BluePrintObject = Get-AzBlueprint -Name $BlueprintName -ManagementGroupId $ManagementGroup

# Add Blueprint ID
$body = Get-Content -Raw -Path $BlueprintAssignmentPath | ConvertFrom-Json
$body.properties.blueprintId = $BluePrintObject.id
$body | ConvertTo-Json | Out-File -FilePath $BlueprintAssignmentPath -Encoding utf8 -Force

New-AzBlueprintAssignment -Name "storage-blueprint" -Blueprint $BluePrintObject -AssignmentFile $BlueprintAssignmentPath -SubscriptionId $SubscriptionId
