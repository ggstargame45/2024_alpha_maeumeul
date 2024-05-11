using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

public class FlowManager : MonoBehaviour
{
    public GameObject[] instantiateList;
    public GameObject cutScene;
    private List<GameObject> activationList = new List<GameObject>();
    private int index = 0;
    
    private void Awake()
    {
        Call(instantiateList);
    }

    private void Next()
    {
        Debug.Log(string.Format("{0}, next",gameObject.name));
        if(index >= activationList.Count)
        {
            End();
            return;
        }
        activationList[index].GetComponent<OfficeWorkManager>().OfficeNext();
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
