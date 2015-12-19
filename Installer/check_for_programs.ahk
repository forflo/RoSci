#SingleInstance Force

;;
; Creates an associative array of associative 
; arrays containing program informations like
; version number, displayname and so on.
returnProgramList()
{
	local softwareKey := "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"
	local display := ""
	local version := ""
	local holder := {}
	local counter := 0
	
	; loops over all registry keys in the hive recursing 
	; just one level and including subkeys
	; parameters 1, and 1 after softwareKey mean 
	; (in order) include subkeys and recurse (level 1
	loop, HKLM, %softwareKey%, 1, 0
	{
		holder[counter] := {}
		loop, HKLM, %softwareKey%%A_LoopRegName%, 1, 0
		{
			; reads the current keys value
			regread, keyval 
			val := A_LoopRegName
			holder[counter][val] := keyval
		}
		
		counter++
	}

	return holder
}

;;
; returns True if a program with name
; searchString is found in the programList
checkForProgram(searchString)
{
	local result := false
	local hl := returnProgramList()

	; loops over all registry keys in the hive recursing 
	; HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\
	; searching for the string searchString in the key value "DisplayName"
	for k, v in hl
	{
		for kk, vv in v
		{
			if(kk == "DisplayName" && RegExMatch(vv, searchString) != 0)
			{
				result := true
			}
		}
	}

	return result
}

;;
; Gets a value from the program list
getValue(programName, programKey)
{
	local hl := returnProgramList()
	
	for k, v in hl
	{
		if(v["DisplayName"] == programName)
		{
			return v[programKey]
		}
	}
	
	return ""
}

;;
; Gets a value from the program list using
; a regular expression. programName can be the regex
getValueFuzzy(programName, key)
{
	local hl := returnProgramList()
	
	for k, v in hl
	{
		;MsgBox, % v["DisplayName"]
		if(RegExMatch(v["DisplayName"], programName) != 0)
		{
			return v[key]
		}
	}
	
	return ""
}