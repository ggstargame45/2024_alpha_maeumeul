using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

public class FlowManager : MonoBehaviour
{
    public GameObject[] officeWorkList;
    public GameObject cutScene;
    private int index = 0;

    private void Start()
    {
        for(int i = 0; i < officeWorkList.Length; i++)
        {
            var target = officeWorkList[i].GetComponent<OfficeWorkManager>();
            target.endWork -= Next;
            target.endWork += Next;
        }
        Next();
    }

    private void Next()
    {
        Debug.Log(string.Format("{0}, next",gameObject.name));
        if(index >= officeWorkList.Length)
        {
            End();
            return;
        }
        officeWorkList[index].GetComponent<OfficeWorkManager>().OfficeNext();
        index += 1;
    }

    private void End()
    {
        if (cutScene)
        {
            Instantiate(cutScene);
        }
    } 
}
