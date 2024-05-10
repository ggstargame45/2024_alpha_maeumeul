using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class StampSignController : MonoBehaviour
{
    public UnityEvent awakeEvents;
    public UnityEvent startEvents;
    public UnityEvent endEvents;

    private void Awake()
    {
        awakeEvents?.Invoke();
    }

    public void StampStart()
    {
        startEvents?.Invoke();
    }

    public void StampEnd()
    {
        endEvents?.Invoke();
    }
}
