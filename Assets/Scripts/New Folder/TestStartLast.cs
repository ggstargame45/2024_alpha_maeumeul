using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestStartLast : MonoBehaviour
{
    public UnityEvent startLastDreamEvent;

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            startLastDreamEvent.Invoke();
        }
    }
}
