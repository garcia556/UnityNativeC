using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bootstrap : MonoBehaviour
{
	private void LogOutput(string message)
	{
		Debug.Log("OUTPUT: " + message);
	}

	void Awake()
	{
		int res = NaPlWrapper.AddNumbers(1, 2);
		this.LogOutput("AddNumbers: " + res.ToString());

		string str = NaPlWrapper.GetStrConstant();
		this.LogOutput("GetStrConstant: " + str);

		uint hash = NaPlWrapper.MurmurHash("data", 0);
		this.LogOutput("MurmurHash: " + hash.ToString());

		Application.Quit();
	}
}

