using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class RealisticRotation : MonoBehaviour
{
    private XRGrabInteractable target;

    private void Awake()
    {
        target = GetComponent<XRGrabInteractable>();
        target.trackRotation = false;
    }

    public void On()
    {
        if (target == null)
        {
            return;
        }

        target.trackRotation = true;
    }

    public void Off()
    {
        if (target == null)
        {
            return;
        }

        target.trackRotation = false;
    }
}
