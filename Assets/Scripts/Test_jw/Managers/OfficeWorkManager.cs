using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class OfficeWorkManager : MonoBehaviour
{
    public UnityEvent awakeEvent;
    public List<UnityEvent> eventList;
    public UnityEvent endEvent;
    public Action endWork;
    int index = 0;

    private void Awake()
    {
        awakeEvent?.Invoke();
    }

    public void Next()
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

        eventList[index]?.Invoke();
        index += 1;
    }

    private void End()
    {
        endWork?.Invoke();
        endEvent?.Invoke();
    }
}
