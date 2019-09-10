<#
 .DESCRIPTION
    Creates Azure BluePrint

 .NOTES
    Author: Neil Peterson
    Intent: Sample to demonstrate Azure BluePrints with Azure DevOps
 #>

 param (
    [string]$SubscriptionId='3762d87c-ddb8-425f-b2fc-29e5e859edaf',
    [string]$ManagementGroup='nepeters-internal',
    [string]$BlueprintName='demo-test-001',
    [string]$AssignmentName='demo-test-001-assignment-two',
    [string]$BlueprintAssignmentPath='./assign/assign-blueprint.json',
    [bool]$Wait,
    [string]$BlueprintVersion='4'
)

if ($BlueprintVersion -eq 'latest') {
   $BluePrintObject = Get-AzBlueprint -Name $BlueprintName -ManagementGroupId $ManagementGroup
} else {
   $BluePrintObject = Get-AzBlueprint -Name $BlueprintName -ManagementGroupId $ManagementGroup -Version $BlueprintVersion
}

# Add Blueprint ID
$body = Get-Content -Raw -Path $BlueprintAssignmentPath | ConvertFrom-Json
$body.properties.blueprintId = $BluePrintObject.id
$body | ConvertTo-Json -Depth 4 | Out-File -FilePath $BlueprintAssignmentPath -Encoding utf8 -Force

# Check for assignment
if (Get-AzBlueprintAssignment -Name $AssignmentName -SubscriptionId $SubscriptionId -erroraction 'silentlycontinue') {
   Set-AzBlueprintAssignment -Name $AssignmentName -Blueprint $BluePrintObject -AssignmentFile $BlueprintAssignmentPath -SubscriptionId $SubscriptionId
} else {
   New-AzBlueprintAssignment -Name $AssignmentName -Blueprint $BluePrintObject -AssignmentFile $BlueprintAssignmentPath -SubscriptionId $SubscriptionId
}

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