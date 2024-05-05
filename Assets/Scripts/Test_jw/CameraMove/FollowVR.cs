using System.Collections;
using System.Collections.Generic;
using Unity.XR.CoreUtils;
using UnityEngine;
using UnityEngine.Events;

public class FollowVR : MonoBehaviour
{
    public UnityEvent awakeEvent;
    private Transform target;

    private void Awake()
    {
        target = GameObject.Find("XR Origin (XR Rig)(Clone)").transform.GetChild(0).GetChild(0);
        Debug.Log(target.gameObject.name);
        gameObject.transform.position = target.position;
        gameObject.transform.rotation = target.rotation;
        awakeEvent?.Invoke();
    }

    private void Update()
    {
        if (target)
        {
            gameObject.transform.position = target.position;
            gameObject.transform.rotation = target.rotation;
        }
        else
        {
            Debug.Log("target no find");
        }
    }
}
