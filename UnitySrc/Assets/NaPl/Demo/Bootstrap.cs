using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bootstrap : MonoBehaviour
{
	public const string LOG_PREFIX = "OUTPUT";

	public UnityEngine.UI.Text lblLog;

	private List<string> logCached = new List<string>();

	private void LogOutput(string message)
	{
		logCached.Add(message);
		message = string.Format("{0}: {1}", LOG_PREFIX, message);
		Debug.Log(message);
	}

	void Awake()
	{
		int res = NaPlWrapper.AddNumbers(1, 2);
		this.LogOutput("AddNumbers: " + res.ToString());

		string str = NaPlWrapper.GetStrConstant();
		this.LogOutput("GetStrConstant: " + str);

		uint hash = NaPlWrapper.MurmurHash("data", 0);
		this.LogOutput("MurmurHash: " + hash.ToString());

		lblLog.text = string.Join("\n", this.logCached.ToArray());

		Application.Quit();
	}
}
