using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class BookShelfClean : MonoBehaviour
{
    public UnityEvent successEvent;
    public UnityEvent cancelEvent;
    public GameObject target;
    private bool isClean = false;
    public void Check()
    {
        if(target.transform.rotation.eulerAngles == new Vector3(0f, 0f, 0f))
        {
            Debug.Log(string.Format("{0} is Cleaned", target.name));
            successEvent?.Invoke();
            isClean = true;
        }
        else
        {
            isClean = false;
        }
    }

    public void Cancel()
    {
        if (isClean)
        {
            cancelEvent?.Invoke();
            isClean = false;
        }
    }
}
