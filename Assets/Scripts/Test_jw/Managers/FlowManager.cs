using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class FlowManager : MonoBehaviour
{
    public GameObjectList[] gameObjectList;
    private int index = 0;

    private void Awake()
    {
        Next();
    }

    public void Next()
    {
        if (!gameObject.activeSelf)
            return;

        if (index >= gameObjectList.Length)
        {
            Debug.Log(gameObject.name + " : index out of range");
            return;
        }
        else
        {
            Call(gameObjectList[index].gameObjects);
            index += 1;
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
            }
        }
    }
}
