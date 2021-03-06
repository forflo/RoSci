﻿#NoEnv
#Include check_for_programs.ahk
#Include manipulate_path.ahk

;;
; This program is used to check the dependencies for
; the rosci package on a given Win-7, Win-Vista or Win-8 system
; (that potentially could be either a 64-Bit or 32-Bit system)
; If the dependencies are met appropriately, the file
; Rosci/src/windows/transitionMatrixDotParams.sce
; will be generated. It'll contain the (locally unique) path
; of the gvpr binary and a random name for a needed temporary file.
;
; This program uses the following library files:
;    * check_for_programs.ahk
;    * manipulate_path.ahk
;
; Unfortunately this program needed to be written, because
; the official installer for the graphviz suite does not set
; the PATH environment variable and thus it is simply not possible
; to solely rely on the scilab builtin for dos command execution.
;;

global downloadGv := "http://graphviz.org/Download_windows.php"
global downloadSc := "http://www.scilab.org/"
global quote := """""""" ; three double quote
global squote := """"
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
	FileAppend, %varname1% = %quote%%gvpr_path%%quote%; `n, %p%
	FileAppend, %varname2% = %squote%TEMPFILEXX12343%squote%; , %p%
}

if(checkDependencies())
{
	bin := build_graphviz_bin()
	if (bin != ""){
		write_parameters("windows\transitionMatrixDotParams.sce", "", build_graphviz_bin() . "gvpr.exe")
	}
}