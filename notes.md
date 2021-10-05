# Exécuter des commandes



```powershell
Get-ChildItem -Path C:\Windows\Temp -File
New-item 
```

#  Demo Object

```powershell
$Objet = Get-Service "SCardSvr" #Récupération de l'object "Service Carte à Puce"

#Récupération Propriétés et des Méthodes
$Objet | Get-Member

#Propriété "immuable"
$Objet.Name

#Propriété dynamique
$Objet.Status

#Méthodes
$Objet.Start()
$Objet.Stop()
```



# Les variables

```powershell
$Variable = "Texte"
$Variable | Get-Member

$Variable = 42
$Variable | Get-Member

$Variable = Get-Process explorer
$Variable | Get-Member
```

### Demo Hashtable

```powershell
$Hashtable = @{
    Package = "VLC"
    Version = "5.3"
    Architecture = "x64"
}


Install-Package -name $Hashtable.Package -version $Hashtable.Version
```

### Demo PSCustom Object

```powershell
$Object = [PSCustomObject]@{
    Computer = "HAL9000"
    OS = "Windows 3.11"
    Disks = "256Mo"
}


#Boucle PsCustomObject

$Result = for ($i = 0; $i -lt 30; $i++) {

    $Number1 = Get-Random -Minimum 1 -Maximum 100
    $Number2 = Get-Random -Minimum 1 -Maximum 100

    [PSCustomObject]@{
        Number1 = $Number1
        Number2 = $Number2
        Resultat = $Number1 * $Number2
    }  
    
}
```

# Maniupulation Objet

```powershell
## On commence par recuperer la liste des services en cours sur notre poste

Get-Service

## Ce resultat nous renvoie très simplement 
## - L'etat sur service
## - Le nom du service
## - La desciption du service
## 
## Mais il ne s'agit la que des informations "basiques" renvoyees par la commande
## Il est possible (lorsqu'elles existent) d'en avoir bien plus.
##
## Pour savoir si c'est le cas, un petit Get-Member

Get-Service | Get-Member


Get-Service | Select-Object *


Get-Service | Select-Object *
Get-Service | Select-Object * | Format-List


Get-Service | Select-Object * | Format-Table

Get-Service | Select-Object Name, Status, StartType,CanStop


Get-Service | Select-Object Name, Status, StartType,CanStop | Where-Object {$_.Status -eq 'Running'}


Get-Service | Select-Object Name, Status, StartType,CanStop | Where-Object {$_.Status -eq 'Running'} | Sort-Object StartType

Get-Service | Select-Object Name, Status, StartType,CanStop | Where-Object {$_.Status -eq 'Running'} | Sort-Object StartType,Name



Get-Service | Select-Object Name, Status, StartType,CanStop | Where-Object {$_.Status -eq 'Running'} | Sort-Object StartType,Name | Group-Object CanStop

Get-ChildItem | Select-Object Name,@{ Name = "Taille en MB" ; expression={ ($_.Length/1MB) } }

Get-Process | Sort-Object CPU -Descending

"System","Application" | ForEach-Object {Get-EventLog -LogName $_ -Newest 5}

Get-ChildItem E:\TEMP | Where-Object {$_.Extension -eq "txt"} | ForEach-Object { $_}

Get-ChildItem E:\ -Directory | ForEach-Object { New-Item -Path $_.FullName -Name "Readme.txt" }

Get-EventLog -LogName Application -Newest 10 | Out-File Log.txt

Get-Process | Export-Clixml .\Processes.xml

$ProcessPreExecution = Get-Process
Start-Process Notepad
$ProcesPostExecution = Get-Process
Compare-Object -ReferenceObject $ProcessPreExecution -DifferenceObject $ProcesPostExecution
```

# Structures

## IF-ELSE

```powershell
#Le blocs IF permet l'éxécution d'un bloc si une condition est remplie.

$test = Get-Service spooler


if (Get-Process notepad -ErrorAction SilentlyContinue)
{
    Write-Host "Condition remplie" 
}


#On peut y rejoindre un bloc Else qui permettra d'éxécuter du code si la condition IF n'est pas rempli.

if ($test -eq "Condition")
{
    Write-Host "Condition remplie" 
}
else
{
    Write-Host "Condition NON-remplie"
}

#Le bloc "Elseif" permet lui de controler une nouvelle condition si la première n'est pas rempli.
$test ="Condition"
if (($test -ne "Truc"))
{
    Write-Host "IF Condition remplie" 
}
elseif ($test -eq "Condition")
{
    Write-Host "ELSEIF Condition remplie"
}


#Ces conditions peuvent être inversé en rajoutant l'opérateur "-not" ou son alias "!" :

if (-not($test -eq "Condition")){...}



#Raccourci IF :

$boolean = $true
$string = "false" 


If($?)
{    
    Write-Host "Aucune erreur à la commande précédent"
}

if (Get-Process notepad)
{
    "Notepad est lancé"
}



```



## FOREACH

```powershell

#La boucle Foreach permet de réitérer une action pour chaque objet contenu dans une collection

$Files = Get-ChildItem "C:\Users\xeph\OneDrive - Synapsys\Formation Powershell\Codes\TESTS"

ForEach ($File in $Files) 
{    
    $NewName = $File.Name -replace "Fichier", "FichierRenommé"
    Rename-Item -Path $File.FullName -NewName $NewName -WhatIf
}

#Le Foreach est un équivalent du ForEach-Object sans l'utilisation du pipeline :

$Files | ForEach-Object {
    $NewName = $_.Name -replace "FichierRenommé", "FichierEncoreRenommé"
    Rename-Item -Path $_.FullName -NewName $NewName -WhatIf 
 } 


$Files = Get-ChildItem $env:TEMP | Sort-Object Length -Descending |Select-Object -First 10

foreach ($file in $files)
{
    $Size = $file.Length/1MB

    
}


#Nous pouvons créer un PSCustomobject via un ForEach
foreach ($Number in 1..10)
{
    [PSCustomObject]@{
        NomFichier = $file.Name
        X = "10"
        Egal = $Number*10
    }  
}
```

## Switch

```powershell
$value = "Second Condition"

switch ($Value)
{    
    '*Condition' { Write-host 'First Action' }    
    'Second Condition' { Write-host 'Second Action' }
    'Second*' { Write-host 'Third Action' }   
}

if ($value -like "*Condition")
{
    Write-host 'First Action'
}
elseif ($value -eq 'Second Condition')
{
    Write-host 'Second Action' 
}
else
{
    Write-host 'action par default'
}

```



## While ..

```powershell
# un bloc While-Do permet d'éxécuter des instructions tant qu'une condition est remplie

$i = 10
while ($true)
{    
    $i
    $i --
}


Start-Process notepad.exe
while (Get-Process notepad -ErrorAction SilentlyContinue)
{  
    Start-Sleep -Milliseconds 500
    Write-Host "Attente de fermeture de Notepad"
}
Write-Host "Notepad a été fermé"


#Le bloc Do-While est identique mais vérifie la condition à la fin, le bloc s'éxécutera donc au minimum une fois.

do {
 
    Start-Sleep -Milliseconds 500
    Write-Host "Attente de fermeture de Notepad"

} while (Get-Process notepad -ErrorAction SilentlyContinue)

#Do-Until est identique mais s'éxécutera jusqu'a ce que la condition soit vrai. Donc "Tant que" la condition est fausse.

Do {
    Start-Sleep -Milliseconds 500
    Write-Host "Attente de Ouverture de Notepad"
}
until (Get-Process notepad -ErrorAction SilentlyContinue)
```



# FUNCTION

## Quick and dirty

```powershell

function Write-Presentation ($name, $age, $Ville)
{ 
    Write-Host "Bonjour $name, Tu as $age ans et tu habites $Ville" -ForegroundColor Green 
}
```



## Quick and nearly not dirty

```powershell
function Write-Presentation2
{
    param
    (
        [Parameter(Mandatory=$true,Position=0)]
        [String]$name,
        [Parameter(Mandatory=$true,Position=1)]
        [int]$age
    )

   Write-host "Bonjour $name, Tu as $age ans"

} 
```



## Avancé

```powershell

Function Write-InColors {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
		[string[]]$Name
	)

	BEGIN 
	{
		Write-Verbose "Debut du traitement"
	}
	PROCESS 
	{
		$AllColors = [Enum]::GetValues([ConsoleColor]) | Where-Object {$_ -ne "Black" }

		$Color = Get-Random -InputObject $AllColors
		Write-Verbose "Traitement de l'objet $Name"
		Write-Host $Name -ForegroundColor $Color	

	}
	END 
	{
		Write-Verbose "Fin du traitement"
	}
}


############################################################################



$Computers = "google.fr", "127.0.0.1", "25.98.74.10", "12.87.125.63"

$ComputersObject = foreach ($Computer in $Computers)
{
	[PSCustomObject]@{
        Name = $Computer
		OS = "Win10","WindowsServer2016","Windows 7","Windows Server 2008R2" | Get-Random
	}
}

$Computers = "google.fr", "127.0.0.1", "25.98.74.10", "12.87.125.63"

Function Ping-IP
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $false)]
		[Alias("Name")]
		[Alias("ServerName")]			
        [string[]]$computername
    )

    BEGIN {}
    PROCESS 
    {

        Write-Verbose "Ping de l'ordinateur $ComputerName"
        Test-Connection -ComputerName $computername -Count 1 -ErrorAction SilentlyContinue

    }
    END {}
}

```

# HELPERS

#### Création Objets

```powershell
1..100 | ForEach-Object {

	[PSCustomObject]@{
        Name = "Computer" + ($_ -as [string])
		OS = "Win10","WindowsServer2016","Windows 7","Windows Server 2008R2" | Get-Random
		Model = "Dell","HP","Lenovo" | Get-Random
		Location = "France","USA","ISS" | Get-Random
	}
}
```

