############################################################################## 
## Get all Az-VMs and mail
## Arunendra Chauhan 

## Function to get all VMs & running status
Function AzureVMS {
$Body =@('Hello There,')
 
$RGs = Get-AzResourceGroup
 
foreach($RG in $RGs)
 
{
 $RGName = $RG.ResourceGroupName
 $VMs = Get-AzVM -ResourceGroupName $RGName
 
 foreach($VM in $VMs)
 
 {
 $VMName =  $VM.Name
 $VMInfo = Get-AzVM -ResourceGroupName $RGName -Name $VMName -Status 
 ForEach($VMStatus in $VMInfo.Statuses){
        if($VMStatus.Code -like "PowerState/*"){
          $VMRunningStatus = $VMStatus.DisplayStatus  
        }
 }
 Write-Host ("VM-Name : " + $VMName + "  &  VM-State : " + $VMRunningStatus ) `n
 $Body += " <br /> VM Name : $VMName  -----  $VMRunningStatus " 
 } 
}
}
## Function to send mail
Function SendMail {  
$MailCreds = Get-Credential -Message "Enter email/pwd and click OK to send mail. Else click cancel" 
$SmtpServer = "smtp.gmail.com" 
$MailTo = "arunendra.chauhan@globant.com" 
$MailFrom = $MailCreds.UserName 
$MailSubject = "Azure VMs Status"
$SMTPPort = "587"
   
Send-MailMessage -To $MailTo -from "$MailFrom" -Subject $MailSubject -Body "$Body" -SmtpServer $SmtpServer -Port $SMTPPort -BodyAsHtml -UseSsl -Credential $MailCreds -DeliveryNotificationOption OnSuccess
  
write-Output " `r`n Custom Message : Azure VM Status Email Sent "
 
}
## Calling functions
AzureVMS
SendMail