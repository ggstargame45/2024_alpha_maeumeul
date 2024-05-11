using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VirtualCameraFollow : MonoBehaviour
{
    private GameObject go;

    private void Awake()
    {
        go = GameObject.Find("XR Origin (XR Rig)").transform.GetChild(0).transform.GetChild(0).gameObject;
    }

    private void Update()
    {
        gameObject.transform.position = go.transform.position;
        gameObject.transform.rotation = go.transform.rotation;
    }
}
