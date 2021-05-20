﻿$Array = @(
"TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA",
"TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA",
"TLS_RSA_WITH_3DES_EDE_CBC_SHA",
"TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA",
"TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA",
"TLS_RSA_WITH_3DES_EDE_CBC_SHA",
"TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA",
"TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA",
"TLS_RSA_WITH_3DES_EDE_CBC_SHA"
)
foreach($chiper in $Array){
	if (Get-TlsCipherSuite -Name $chiper) {
		Disable-TlsCipherSuite -Name $chiper
	}	
}
(Get-TlsCipherSuite).Name