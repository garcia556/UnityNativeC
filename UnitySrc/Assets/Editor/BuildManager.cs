using UnityEditor;

class BuildManager
{
	public const string KEY_OUTPUT = "-output";
	public const string KEY_BUILDTARGET = "-buildTarget";

	public static void Run()
	{
		string sceneActive = UnityEngine.SceneManagement.SceneManager.GetActiveScene().name;
		string[] scenes = { "Assets/Main.unity" };

		string output = null;
		string buildTarget = null;

		string[] args = System.Environment.GetCommandLineArgs();
		for (int i = 1; i < args.Length; i++)
		{
			if (args[i - 1].Equals(KEY_OUTPUT))      output      = args[i];
			if (args[i - 1].Equals(KEY_BUILDTARGET)) buildTarget = args[i];
		}

		BuildTarget target = (BuildTarget)System.Enum.Parse(typeof(BuildTarget), buildTarget);

		BuildPipeline.BuildPlayer(scenes, output, target, BuildOptions.None);
	}
}
