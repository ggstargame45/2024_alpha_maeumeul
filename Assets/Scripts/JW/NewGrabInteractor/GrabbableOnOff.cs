using Autohand;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GrabbableOnOff : MonoBehaviour
{
    private Grabbable grabbable;
    private void Awake()
    {
        grabbable = gameObject.GetComponent<Grabbable>();
        grabbable.enabled = false;
    }

    public void StartWork()
    {
        grabbable.enabled = true;
    }

    public void EndWork()
    {
        grabbable.enabled = false;
        var rigid = gameObject.GetComponent<Rigidbody>();
        Destroy(rigid);
    }
}
