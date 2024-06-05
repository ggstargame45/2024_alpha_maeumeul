using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class WorkHelper : MonoBehaviour
{
    public UnityEvent startHelp;
    public UnityEvent itemHelp;
    public UnityAction firstGrab;
    public UnityEvent workHelp;
    public UnityAction firstWork;
    public UnityEvent endHelp;
    public UnityAction lastWork;
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
        firstGrab?.Invoke();
        isGrabbed = true;
    }

    public void HelperWork() {
        if (isUsed) return;
        workHelp?.Invoke();
        firstWork?.Invoke();
        isUsed = true;
    }

    public void HelperEnd()
    {
        endHelp?.Invoke();
        lastWork?.Invoke();
    }
}
