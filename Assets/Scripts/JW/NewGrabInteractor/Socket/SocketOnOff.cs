using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SocketOnOff : MonoBehaviour
{
    private BoxCollider box;
    private void Awake()
    {
        box = gameObject.GetComponent<BoxCollider>();
        box.enabled = false;
    }

    public void StartWork()
    {
        box.enabled = true;
    }
}
