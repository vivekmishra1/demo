get-windowsfeature
Install-windowsfeature AD-domain-services
Import-Module ADDSDeployment
Install-AddsForest   #and it will ask for domain name and credentials, it will take some time to install it and server will automatically get restarted.