using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class OfficeWorkManager : MonoBehaviour
{
    public UnityEvent startEvent;
    public List<UnityEvent> eventList;
    public UnityEvent endEvent;
    public Action endWork;
    int index = 0;

    private void Start()
    {
        startEvent?.Invoke();
    }

    public void OfficeNext()
    {
        if (index > eventList.Count)
        {
            Debug.Log("in " + gameObject.name + ", OfficeWorkManager : index out of range");
            return;
        }
        else if (index == eventList.Count)
        {
            End();
            index += 1;
            return;
        }
        Debug.Log(string.Format("{0} next", gameObject.name));
        eventList[index]?.Invoke();
        index += 1;
    }

    private void End()
    {
        Debug.Log(string.Format("{0} end", gameObject.name));
        endWork?.Invoke();
        endEvent?.Invoke();
    }
}
