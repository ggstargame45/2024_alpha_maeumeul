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

    private void Call(GameObject[] gameObjects)
    {
        for(int i = 0; i < gameObjects.Length; i++)
        {
            var go = Instantiate(gameObjects[i]);
            var off = go.GetComponent<OfficeWorkManager>();
            if (off)
            {
                off.endWork += Next;
                activationList.Add(go); //버그있음 이유는 모름
            }
        }

        Next();
    }
}
