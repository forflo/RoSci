#NoEnv
#Include check_for_programs.ahk
#Include manipulate_path.ahk

global downloadGv := "http://graphviz.org/Download_windows.php"
global downloadSc := "http://www.scilab.org/"

checkDependencies()
{
	if(getValue("Graphviz", "DisplayVersion") == "")
	{
		MsgBox, You need to install Graphviz
		Run, %downloadGv%
	}
	
	if(getValueFuzzy("scilab", "DisplayName") == "")
	{
		MsgBox, You need to install Graphviz
		Run, %downloadSc%
	}
}


checkDependencies()