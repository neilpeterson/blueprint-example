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
   [string]$BlueprintPath
)

Import-AzBlueprintWithArtifact -Name $BlueprintName -ManagementGroupId $ManagementGroup -InputPath $BlueprintPath -Force
$BluePrintObject = Get-AzBlueprint -Name $BlueprintName -ManagementGroupId $ManagementGroup
Publish-AzBlueprint -Blueprint $BluePrintObject -Version 3

# Import-AzBlueprintWithArtifact -Name $BlueprintName -SubscriptionId $SubscriptionId -InputPath $BlueprintPath
# $BluePrintObject = Get-AzBlueprint -Name $BlueprintName
# Publish-AzBlueprint -Blueprint $BluePrintObject -Version 1