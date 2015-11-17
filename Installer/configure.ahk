#NoEnv
#Include check_for_programs.ahk
#Include manipulate_path.ahk

global downloadGv := "http://graphviz.org/Download_windows.php"
global downloadSc := "http://www.scilab.org/"
global quote := """""""" ; three double quote
global dontedit := "// This file is generated on windows by`n// DO NOT EDIT!`n////`n`n"

checkDependencies()
{
	if(getValue("Graphviz", "DisplayVersion") == "")
	{
		MsgBox, You need to install Graphviz
		Run, %downloadGv%
		return false
	}
	
	if(getValueFuzzy("scilab", "DisplayName") == "")
	{
		MsgBox, You need to install Graphviz
		Run, %downloadSc%
		return false
	}
	
	return true
}

build_graphviz_bin(){
	local result := ""
	local version := getValue("Graphviz", "DisplayVersion")
	local envvar := "PROGRAMFILES(X86)"
	local progfiles := ""
	EnvGet, progfiles, %envvar%
	
	if (progfiles = ""){
		result := "C:\Program Files\"
	} else {
		result := "C:\Program Files (x86)\"
	}
	
	if (version = ""){
		return ""
	}
	
	return result . "Graphviz" . version . "\" .  "bin\"
}

write_parameters(filename, path, gvpr_path)
{
	local varname1 := "rosci_path_gvpr"
	local varname2 := "rosci_tempfile_name"
	local p := ""
	if (path == ""){
		p := filename
	} else {
		p := path . "\" . filename
	}
	FileDelete, %p%
	FileAppend, %dontedit%, %p%
	FileAppend, %varname1% = %quote%%gvpr_path%%quote%; , %p%
}

if(checkDependencies())
{
	local bin = build_graphviz_bin()
	if (bin != ""){
		write_parameters("foobar", "", build_graphviz_bin() . "gvpr.exe")
	}
} 