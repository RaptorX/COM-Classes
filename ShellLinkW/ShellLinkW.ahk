/*
class: ShellLinkW
implements the IShellLinkW interface and exposes methods that create, modify, and resolve Shell links.

Requirements:
	AutoHotkey - AHK v2 alpha
	OS - Windows XP / Windows 2000 Server or higher
	Base classes - Unknown
	Helper classes - SLGP, SLR, SW, WIN32_FIND_DATA

Further documentation:
	- *msdn* (http://msdn.microsoft.com/en-us/library/windows/desktop/bb774950)

Remarks:
	To create a shortcut, query the instance for IPersistFile and call its Save() method.
*/
class ShellLinkW extends Unknown
{
	/*
	Field: CLSID
	This is CLSID_ShellLink. It is required to create an instance.
	*/
	static CLSID := "{00021401-0000-0000-C000-000000000046}"

	/*
	Field: IID
	This is IID_IShellLinkW. It is required to create an instance.
	*/
	static IID := "{000214F9-0000-0000-C000-000000000046}"

	/*
	Method: GetPath
	Gets the path and file name of a Shell link object.

	Parameters:
		byRef STR path - receives the path and file name of the Shell link object.
		UINT flags - a combination of flags that specify the type of path information to retrieve. You can use the fields of the SLGP class for convenience.
		[opt] byRef WIN32_FIND_DATA data - receives a WIN32_FIND_DATA instance that contains information about the Shell link object.

	Returns:
		BOOL success - true on success, false otherwise
	*/
	GetPath(byRef path, flags, byRef data := 0)
	{
		VarSetCapacity(s, 636, 0)
		VarSetCapacity(path, 520, 0)
		hr := DllCall(NumGet(this.vt+03*A_PtrSize), "ptr", this.ptr, "str", path, "int", 260, "ptr", s, "uint", flags)
		data := new WIN32_FIND_DATA(s)
		return this._Error(hr)
	}

	/*
	Method: GetIDList

	Remarks:
		Not implemented
	*/
	GetIDList(ByRef idlist)
	{
		;return DllCall(NumGet(this.vt+04*A_PtrSize), "Ptr", this.ptr, "Ptr", idlist)
	}

	/*
	Method: SetIDList

	Remarks:
		Not implemented
	*/
	SetIDList(idlist)
	{
		;return DllCall(NumGet(this.vt+05*A_PtrSize), "Ptr", this.ptr, "Ptr", idlist)
	}

	/*
	Method: GetDescription
	Gets the description string for a Shell link object.

	Parameters:
		[opt] INT maxChars - the maximum number of characters to retrieve. By default 300.

	Returns:
		STR description - the description string.
	*/
	GetDescription(maxChars := 300)
	{
		VarSetCapacity(descr, maxChars * 2, 0)
		this._Error(DllCall(NumGet(this.vt+06*A_PtrSize), "ptr", this.ptr, "str", descr, "int", maxChars))
		return descr
	}

	/*
	Method: SetDescription
	Sets the description for a Shell link object. The description can be any application-defined string.

	Parameters:
		STR description - the new description string

	Returns:
		BOOL success - true on success, false otherwise
	*/
	SetDescription(description)
	{
		return this._Error(DllCall(NumGet(this.vt+07*A_PtrSize), "Ptr", this.ptr, "str", description))
	}

	/*
	Method: GetWorkingDirectory
	Gets the name of the working directory for a Shell link object.

	Returns:
		STR dir - the working directory
	*/
	GetWorkingDirectory()
	{
		VarSetCapacity(dir, 260 * 2, 0)
		this._Error(DllCall(NumGet(this.vt+08*A_PtrSize), "Ptr", this.ptr, "str", dir, "Int", 260))
		return dir
	}

	/*
	Method: SetWorkingDirectory
	Sets the name of the working directory for a Shell link object.

	Parameters:
		STR dir - the name of the new working directory

	Returns:
		BOOL success - true on success, false otherwise
	*/
	SetWorkingDirectory(dir)
	{
		return this._Error(DllCall(NumGet(this.vt+09*A_PtrSize), "Ptr", this.ptr, "str", dir))
	}

	/*
	Method: GetArguments
	Gets the command-line arguments associated with a Shell link object.

	Parameters:
		[opt] INT size - the maximum number of characters to retrieve. By default 300.
	Returns:
		STR args - the arguments
	*/
	GetArguments(size := 300)
	{
		VarSetCapacity(args, size * 2, 0)
		this._Error(DllCall(NumGet(this.vt+10*A_PtrSize), "Ptr", this.ptr, "str", args, "Int", size))
		return args
	}

	/*
	Method: SetArguments
	Sets the command-line arguments for a Shell link object.

	Parameters:
		STR args - the new command-line arguments

	Returns:
		BOOL success - true on success, false otherwise
	*/
	SetArguments(args)
	{
		return this._Error(DllCall(NumGet(this.vt+11*A_PtrSize), "Ptr", this.ptr, "str", args))
	}

	/*
	Method: GetHotkey
	Gets the keyboard shortcut (hot key) for a Shell link object.

	Remarks:
		Not implemented
	*/
	GetHotkey()
	{
		this._Error(DllCall(NumGet(this.vt+12*A_PtrSize), "Ptr", this.ptr, "short*", hotkey))
		return hotkey
	}

	/*
	Method: SetHotkey
	Sets a keyboard shortcut (hot key) for a Shell link object.

	Remarks:
		Not implemented
	*/
	SetHotkey(hotkey)
	{
		return this._Error(DllCall(NumGet(this.vt+13*A_PtrSize), "Ptr", this.ptr, "short", hotkey))
	}

	/*
	Method: GetShowCmd
	Gets the show command for a Shell link object.

	Returns:
		INT cmd - an integer describing the show command. You can compare this to the fields of the SW class for convenience.
		Supported commands include: SW.SHOWNORMAL, SW.SHOWMAXIMIZED, SW.SHOWMINNOACTIVE
	*/
	GetShowCmd()
	{
		this._Error(DllCall(NumGet(this.vt+14*A_PtrSize), "Ptr", this.ptr, "int*", cmd))
		return cmd
	}

	/*
	Method: SetShowCmd
	Sets the show command for a Shell link object. The show command sets the initial show state of the window.

	Parameters:
		INT cmd - an integer describing the show command. This must be one of the values listed under <GetShowCmd>.

	Returns:
		BOOL success - true on success, false otherwise
	*/
	SetShowCmd(cmd)
	{
		return this._Error(DllCall(NumGet(this.vt+15*A_PtrSize), "Ptr", this.ptr, "int", cmd))
	}

	/*
	Method: GetIconLocation
	Gets the location (path and index) of the icon for a Shell link object.

	Parameters:
		byRef STR path - receives the path of the file containing the icon
		byRef INT index - receives the index of the icon

	Returns:
		BOOL success - true on success, false otherwise
	*/
	GetIconLocation(ByRef path, ByRef index)
	{
		VarSetCapacity(path, 260 * 2, 0)
		return this._Error(DllCall(NumGet(this.vt+16*A_PtrSize), "Ptr", this.ptr, "str", path, "int", 260, "int*", index))
	}

	/*
	Method: SetIconLocation
	Sets the location (path and index) of the icon for a Shell link object.

	Parameters:
		STR path - the path of the file containing the icon
		INT index - the index of the icon

	Returns:
		BOOL success - true on success, false otherwise
	*/
	SetIconLocation(path, index)
	{
		return this._Error(DllCall(NumGet(this.vt+17*A_PtrSize), "Ptr", this.ptr, "str", path, "int", index))
	}

	/*
	Method: SetRelativePath
	Sets the relative path to the Shell link object.

	Parameters:
		STR path - the new relative path. It should be a file name, not a folder name.

	Returns:
		BOOL success - true on success, false otherwise
	*/
	SetRelativePath(path)
	{
		return this._Error(DllCall(NumGet(this.vt+18*A_PtrSize), "Ptr", this.ptr, "str", path, "uint", 0))
	}

	/*
	Method: Resolve
	Attempts to find the target of a Shell link, even if it has been moved or renamed.

	Parameters:
		HWND hwnd - A handle to the window that the Shell will use as the parent for a dialog box. The Shell displays the dialog box if it needs to prompt the user for more information while resolving a Shell link.
		UINT fFlags - action flags. You can use the fields of the SLR class for convenience.

	Returns:
		BOOL success - true on success, false otherwise
	*/
	Resolve()
	{
		return this._Error(DllCall(NumGet(this.vt+19*A_PtrSize), "ptr", this.ptr, "uptr", hwnd, "uint", flags))
	}

	/*
	Method: SetPath
	Sets the path and file name of a Shell link object.

	Parameters:
		STR path - the new path

	Returns:
		BOOL success - true on success, false otherwise
	*/
	SetPath(path)
	{
		return this._Error(DllCall(NumGet(this.vt+20*A_PtrSize), "Ptr", this.ptr, "str", path))
	}
}