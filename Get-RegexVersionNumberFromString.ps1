
function Get-VersionFromStringRegex
{
<#
	.SYNOPSIS
		Parses provided strings for SymVer version number using a variety of Regex patterns.  Works on multiple strings, returns either matched string or a table with original/new values.
	
	.DESCRIPTION
	    ===================================== GET-VERSIONFROMSTRINGREGEX ==============================================
        Version 1.0.0
                                                                                uthor:  Justin Brazil
                                                                                License:  MIT
                                                                                Date:  07/06/2019
    
        Parses provided strings for SymVer version number using a variety of Regex patterns. Works on multiple strings, returns either matched string or a table with original/new values.
		
		Features a number of build-in RegEx patterns and allows you to provide your own.
		
		Features a numbrt of built-in test file names for use when testing/validating patterns.
		
		Works with 3 or 4 digit strings (SymVer + BuildNumber)
		       
		Use This Site for Testing/Building Regex Patterns:  https://regex101.com/r/tM3aF5/3
	
	.PARAMETER String
		The target string or string array against which to perform the pattern match.
	
	.PARAMETER OutputFormat
		The output format for the matched string [Version] / [String]
	
	.PARAMETER ReturnComparisonTable
		Returns comparison table of original strings and Regex matches for use in debugging/testing.
	
	.PARAMETER RegexString
		The built-in regex pattern to use when performing a match against the target string(s).  You must use the -ManualRegexPattern parameter to provide your own matching pattern.
	
	.PARAMETER ManualRegexString
		Overrides the built-in algorithms and allows you to provide a custom regex algoritm to use in matching operation.
	
	.PARAMETER EnableTestStrings
		Switch parameter to test your regex pattern against a table of pre-built file names.  Returns a comparison table showing your results.
	
	.PARAMETER Test_FileNames
		A pre-built list of various test filenames/file patterns to use when testing your Regex patterns.  Leave default values unless providing your own test list.
	
	.EXAMPLE
		PS C:\> Get-VersionFromStringRegex
	
	.NOTES
		Additional information about the function.
#>
	
	param
	(
		[Parameter(ValueFromPipeline = $true,
		           ValueFromPipelineByPropertyName = $true,
		           ValueFromRemainingArguments = $true,
		           Position = 0,
		           HelpMessage = 'The target string or string array against which to perform the pattern match.')]
		[string[]]
		$String,
		[Parameter(HelpMessage = 'The output format for the matched string [Version] / [String]')]
		[ValidateSet('string', 'Version')]
		[string]
		$OutputFormat = 'Version',
		[Parameter(HelpMessage = 'Returns comparison table of original strings and Regex matches for use in debugging/testing.')]
		[switch]
		$ReturnComparisonTable,
		[Parameter(HelpMessage = 'The built-in regex pattern to use when performing a match against the target string(s).  You must use the -ManualRegexPattern parameter to provide your own matching pattern.')]
		[ValidateSet('(\d+\.\d+(\.\d+)?(\.\d+))', '\s*(\d+\.\d+(\.\d+)?(\.\d+))', '\s*(\d+\.\d+(\.\d+)?(\.\d+))\s*', '\s*(\d+\.\d+(\.\d+)?(\.\d+))\s*', '(?<ver>\d+(?:\.\d+)+)'''')', '\s+Version \d+\.\d+\.\d+\s+', '.*_(\d+(\.\d+){1,3}).*')]
		[string]
		$RegexString = "(\d+\.\d+(\.\d+)?(\.\d+))",
		[Parameter(HelpMessage = 'Overrides the built-in algorithms and allows you to provide a custom regex algoritm to use in matching operation.')]
		[ValidateNotNullOrEmpty()]
		[string]
		$ManualRegexString,
		[Parameter(HelpMessage = 'Switch parameter to test your regex pattern against a table of pre-built file names.  Returns a comparison table showing your results.')]
		[switch]
		$EnableTestStrings,
		[Parameter(HelpMessage = 'A pre-built list of various test filenames/file patterns to use when testing your Regex patterns.  Leave default values unless providing your own test list.')]
		[array]
		$Test_FileNames = @(
                    'Get-PowerShell4 (5.1.1).ps1'
                    'Test-PowerShell4 (v5.1.1).ps1'
                    'Get-APSAzureHelpers.6.1.11.ps1'
                    'Get-APSAzureHelpers_0.0.1 test.ps1'
                    'Core_1.2.4_Prod'
                    'Core_1.2.6.xlsx'
                    'Get-SomeScriptVersion5_v1.36.1_Prod'
                    'Core_1456.4.412.45'
                    'TestFile v1.0.0.psm1'
                    'TestTrustMe Version 106.0.450.15.bat'
                    'DateTest_04.21.16.xlsx'
                    'Get-APSAzureHelpers 1.10.4.ps1'
                    'Get-APSAzureHelpers 1.10.4ALT.ps1'
                    "D:\VisualStudioRepos\AzureDevops\JB_PowerShell\JB_AzureHelpers\Module\JBAzureHelpers\1.0.4"
                    "D:\VisualStudioRepos\AzureDevops\JB_PowerShell\JB_AzureHelpers\Module\JBAzureHelpers\1.0.4\FunctionDatafile.xml"
                    "C:\Users\jbrazil.JB\AppData\Local\QNAP\Qsync\FolderPairs\1\.view\Scripting\PowerShell\Projects\TN Horizons 1.0"
                    "TN Horizons CLient  1.0.0 (DropBox API Functions v3.3.2).ps1.file"
                    "C:\Users\jbrazil.JB\AppData\Local\QNAP\Qsync\FolderPairs\1\.view\Scripting\PowerShell\Projects\Egnyte API\Egnyte API 1.0.0(Conflicted copy 2017-05-25 from JB-ASUSLAPTOP).ps1.file"
                    "C:\Users\jlocal\AppData\Local\QNAP\Qsync\FolderPairs\3\.destcache\PowerShell\Projects\TN Horizons 1.0\TN Horizons Server 1.0.0 (DropBox API Functions v3.3.2).ps1"
                    )
	    )

	    ### WRITE TO CONSOLE ###
        Write-Host "Match-VersionFromStringRegex:  Attempting to match version number from input string(s)" -ForegroundColor Cyan
        Write-Host "Regex Pattern: $($RegexString)"   -ForegroundColor Cyan
        Write-Host "Input String:  $($String)" -ForegroundColor Cyan
        
        ### SELECT REGEX ###
        if ($ManualRegexString){$Regex = $ManualRegexString}
        else {$RegexString = $RegexString}

        ### POPULATE TARGET STRINGS ###
        if ($EnableTestStrings){ $TargetStrings = $Test_FileNames}
        else {$TargetStrings = $String }

        ### OUTPUT ###
        $OutputArray = @()
        
        ### PROCESS STRINGS ###
       
        if ($ReturnComparisonTable)
            {    
            ### BUILD COMARISON TABLE ###
            $TargetStrings | % {
                $RegMatch = ([regex]::Match($_ , $RegexString ))
                if ($RegMatch.Success)
                    { Write-Host "Regex Version match found in string: $($RegMatch.Value)" -ForegroundColor Cyan
                    $RegTemp = New-Object -TypeName PSObject -Property @{
                        new = [string]([regex]::Match($_ , $RegexString )).Value;
                        newver = [version]([regex]::Match($_ , $RegexString )).Value;
                        original = $_
                        }
                    $OutputArray += $RegTemp
                    }
                } 
            }
        else{
            ### STANDARD OUTPUT MODE (NO COMPARISON TABLE) ###
            if ($OutputFormat -like 'Version'){$OutputArray += ($TargetStrings | % {$RegMatch = ([regex]::Match($_ , $RegexString )); if ($RegMatch){$RegMatch.Value; Write-Host "Regex Version match found in string: $($RegMatch.Value)" -ForegroundColor Cyan } } )    }
            elseif ($OutputFormat -like 'String'){$OutputArray += ($TargetStrings | % {$RegMatch = ([regex]::Match($_ , $RegexString )); if ($RegMatch){$RegMatch.Value; Write-Host "Regex Version match found in string: $($RegMatch.Value)" -ForegroundColor Cyan } } )    }
            }

    ### OUTPUT REPORTING AND LOGIC ###
    if ($OutputArray){
        Write-Host "Get-VersionFromStringRegex: Successfully matched one or more values!" -ForegroundColor Green
        return $OutputArray
        }
    else {Write-Host "Get-VersionFromStringRegex:  No matches found" -ForegroundColor Yellow}
}



