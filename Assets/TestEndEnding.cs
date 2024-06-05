using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestEndEnding : MonoBehaviour
{
    public UnityEvent startEndingEvent;

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            startEndingEvent.Invoke();
        }
    }
}
