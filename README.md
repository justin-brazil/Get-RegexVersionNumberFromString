# Get-RegexVersionNumberFromString

**Version** 1.0.0

## SYNOPSIS

Parses provided strings for SymVer version number using a variety of Regex patterns.  Works on multiple strings, returns either matched string or a table with original/new values.
	
## DESCRIPTION
	    
        
**Author:**  Justin Brazil
**License:**  MIT
**Date:**  07/06/2019
   
### Windows PowerShell Regex SymVer Matching Utility.   
   
Parses provided strings for SymVer version number using a variety of Regex patterns. Works on multiple strings, returns either matched string or a table with original/new values.
		
* Features a number of build-in RegEx patterns and allows you to provide your own.
		
* Features a numbrt of built-in test file names for use when testing/validating patterns.
		
* Works with 3 or 4 digit strings (SymVer + BuildNumber)
		       
* Use This Site for Testing/Building Regex Patterns:  https://regex101.com/r/tM3aF5/3
	
###	.PARAMETER String

The target string or string array against which to perform the pattern match.
	
###	.PARAMETER OutputFormat

The output format for the matched string [Version] / [String]
	
###	.PARAMETER ReturnComparisonTable

Returns comparison table of original strings and Regex matches for use in debugging/testing.
	
###	.PARAMETER RegexString

The built-in regex pattern to use when performing a match against the target string(s).  You must use the -ManualRegexPattern parameter to provide your own matching pattern.
	
###	.PARAMETER ManualRegexString

Overrides the built-in algorithms and allows you to provide a custom regex algoritm to use in matching operation.
	
###	.PARAMETER EnableTestStrings

Switch parameter to test your regex pattern against a table of pre-built file names.  Returns a comparison table showing your results.
	
###	.PARAMETER Test_FileNames

A pre-built list of various test filenames/file patterns to use when testing your Regex patterns.  Leave default values unless providing your own test list.
	
###	.EXAMPLE

	PS C:\> Get-VersionFromStringRegex -String "\\MyDomain.com\MyFileServer\MyShare\SomeFilePath\MyScript.2.15.0.152.ps1"
	
	PS C:\> Get-VersionFromStringRegex -EnableTestStrings
	
###	.NOTES
		
Use "Comparison Table" feature to test your regex patterns against an array of dummy flienames.

	



