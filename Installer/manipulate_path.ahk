#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

; Sets the system-wide environment variable Path
; oldPath = current value of the registry key
; gvprPath = Path to the bin utilities of the graphviz package
appendToPath(path)
{
	local pathPath := "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
	RegRead, oldPath, %pathPath%, Path
	local newPath := oldPath . ";" . path

	RegWrite, REG_EXPAND_SZ, %pathPath%, PATH, %newPath%
	return
}