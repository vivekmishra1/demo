############################################################################## 
## Website Availability Monitoring 
## Arunendra Chauhan 


FUNCTION website {
 
## The Website URI list to test 
  
$URLs = @("www.google.com", "www.facebook.com", "www.dummyurltoteesting.com") 
  $Result = @() 
   
   
  Foreach($Uri in $URLs) { 
  try{ 
  $request = $null 

   ## Request the URI, and measure how long the response took. 
  $request = Invoke-WebRequest -Uri $uri
  } catch { 
    
   $request = $_.Exception.Response 
    
  } 
    
  $result += [PSCustomObject] @{ 
   
  Uri = $uri; 
  StatusCode = [int] $request.StatusCode; 
  StatusDescription = $request.StatusDescription; 
  
   
    
  } 
 
} 
    #Prepare email body in HTML format 
if($result -ne $null) 
{ 
    $Outputreport = "<HTML><TITLE>Website Availability Report</TITLE> `
    <BODY background-color:peachpuff><font color =""#99000"" face=""Microsoft Tai le""> `
    <H2> Website Availability Report </H2></font><Table border=1 cellpadding=0 cellspacing=0> `
    <TR bgcolor=gray align=center><TD><B>WEBSITE</B></TD><TD><B>StatusCode</B></TD> `
    <TD><B>AvailableStatus</B></TD></TR>" 

    Foreach($Entry in $Result) 
    { 
        if($Entry.StatusCode -ne "200") 
        { 
            $Outputreport += "<TR bgcolor=red>" 
        } 
        else 
        { 
            $Outputreport += "<TR bgcolor=green>" 
            
        } 
        $Outputreport += "<TD>$($Entry.uri)</TD><TD align=center>$($Entry.StatusCode)</TD> `
        <TD align=center>$($Entry.StatusDescription)</TD></TR>" 
    } 
    $Outputreport += "</Table></BODY></HTML>" 
} 
 
$Outputreport | out-file C:\Test.htm 
Invoke-Expression C:\Test.htm   
}
website