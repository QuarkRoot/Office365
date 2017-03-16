<#
.SYNOPSIS 
    Script para setear el correo y/o celular para recuperar
    la clave de Office365 
.DESCRIPTION  
    Script para setear el correo y/o celular para recuperar la clave 
    de Office365, recibe un csv como  argumento o sino por defecto 
    busca un en el mismo directorio donde está corriendo el script
    llamado DatosUsuarios.csv

.NOTES 
    NOmbre  : SetUserAlternativeEmailPhone.ps1 
    Autor     : felipe Schneider - felipe.schneider@pyxis.com.uy

.PARAMETER Archivo 
    #>

###############################################################################
#Script Input Parameters
###############################################################################
PARAM
(
 [string]$Archivo = "DatosUsuarios.csv"
)

Write-Host "El archivo es: " $Archivo
#$UserData = "DatosUsuarios.csv"

If (Test-Path $Archivo)
{
    $UserCredential = Get-Credential
    Try{
        Connect-MsolService -Credential $UserCredential -ErrorAction Stop
        $file = Import-Csv $Archivo -Delimiter ";"

        Foreach ($line in $file)
        {
            Write-Host "############ Cambiando el usuario "  $line.UserName ", nuevo correo: " $line.Email ", nuevo Celular: " $line.Cel
            Set-MsolUser -UserPrincipalName $line.UserName -AlternateEmailAddresses $line.Email -MobilePhone $line.Cel
            #get-MsolUser -UserPrincipalName $line.UserName | select DisplayName, UserPrincipalName, AlternateEmailAddresses, MobilePhone   
        }
        Write-Host "############ Finalizó el script"

    }
    Catch [Microsoft.Online.Administration.Automation.MicrosoftOnlineException]
    {
        Write-Host "Error de credenciales"

    }
    Catch [System.IO.FileNotFoundException]
    {
        Write-Host "No existe el archivo de usuarios"

    }
    Catch 
    {
        Write-Host "Error desconocido"

    }
}else
{
    Write-Host "No existe el archivo"
}