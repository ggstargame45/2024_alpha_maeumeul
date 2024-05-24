using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestStartUIZone : MonoBehaviour
{
    public UnityEvent startUIEvent;


    
    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            startUIEvent.Invoke();
            gameObject.SetActive(false);
        }
    }

}
