using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Events;

public class StampSign : MonoBehaviour
{
    public UnityEvent onStamped;

    public void Stamped()
    {
        onStamped?.Invoke();
    }

}
