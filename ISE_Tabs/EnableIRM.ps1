# enable IRM licensing

Set-IRMConfiguration –RMSOnlineKeySharingLocation “https://sp-rms.na.aadrm.com/TenantManagement/ServicePartner.svc“

Import-RMSTrustedPublishingDomain -RMSOnline -name “RMS Online”

Set-IRMConfiguration -InternalLicensingEnabled $true

Test-IRMConfiguration -sender Ariel.Hart@colonystarwood.com