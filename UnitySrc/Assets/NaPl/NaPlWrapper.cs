using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public static class NaPlWrapper
{
#if UNITY_WEBGL && !UNITY_EDITOR
	public const string PLUGIN_REFERENCE = "__Internal";
#else
	public const string PLUGIN_REFERENCE = "NaPlContent";
#endif

#region Mapping to native code
	[DllImport(PLUGIN_REFERENCE)] private static extern int add_numbers(int x, int y);
	[DllImport(PLUGIN_REFERENCE)] private static extern uint murmurhash(string k, uint l, uint s);
	[DllImport(PLUGIN_REFERENCE)] private static extern System.IntPtr get_str_constant();
#endregion

#region External interface
	public static uint MurmurHash(string d, uint s)
	{
		return murmurhash(d, (uint)(d.Length), s);
	}

	public static int AddNumbers(int x, int y)
	{
		return add_numbers(x, y);
	}

	public static string GetStrConstant()
	{
		return Marshal.PtrToStringAuto(get_str_constant());
	}
#endregion
}
