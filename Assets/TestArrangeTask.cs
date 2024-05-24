using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestArrangeTask : MonoBehaviour
{
    public UnityEvent taskSuccessEvent;
    // Start is called before the first frame update

    public GameObject shootTask;

    public bool isAvailable = false;


    public void taskSuccess()
    {
        taskSuccessEvent.Invoke();
    }
}
