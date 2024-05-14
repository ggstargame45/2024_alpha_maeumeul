using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class WorkHelper : MonoBehaviour
{
    public UnityEvent startHelp;
    public UnityEvent itemHelp;
    public UnityEvent workHelp;
    public UnityEvent endHelp;
    private bool isGrabbed = false;
    private bool isUsed = false;

    public void HelperStart()
    {
        startHelp?.Invoke();
    }

    public void HelperItem()
    {
        if (isGrabbed) return;
        itemHelp?.Invoke();
        isGrabbed = true;
    }

    public void HelperWork() {
        if (isUsed) return;
        workHelp?.Invoke();
        isUsed = true;
    }

    public void HelperEnd()
    {
        endHelp?.Invoke();
    }
}
