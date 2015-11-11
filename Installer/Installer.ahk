#NoEnv

global pathPath := "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
global oldPath := get_path()
global gvprPath := "C:\Program Files\Graphviz2.38\bin"
global infoText := "Pfad Variable wurde erfolgreich gesetzt. Bitte starten Sie den Computer neu, "
global infoText2 := "da nur so die Änderungen übernommen werden."

set_path()
{
	local newPath := oldPath . ";" . gvprPath
	RegWrite, REG_EXPAND_SZ, %pathPath%, PATH, %newPath%
	return
}

get_path()
{
	local out := ""
	RegRead, out, %pathPath%, Path
	return out
}

set_path()
MsgBox, % infoText . infoText2