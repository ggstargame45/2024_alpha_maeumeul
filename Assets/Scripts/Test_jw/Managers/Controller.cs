using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour
{
    static Controller s_instance;
    public static Controller Instance { get { init(); return s_instance; } }

    FlowManager _flow = new FlowManager();

    public static FlowManager Flow { get { return Instance._flow; } }

    static void init()
    {
        if (s_instance == null)
        {
            GameObject go = GameObject.Find("@Controller");
            if (go == null)
            {
                go = new GameObject { name = "@Controller" };
                go.AddComponent<Controller>();
            }
            DontDestroyOnLoad(go);
            s_instance = go.GetComponent<Controller>();
        }
    }
}
