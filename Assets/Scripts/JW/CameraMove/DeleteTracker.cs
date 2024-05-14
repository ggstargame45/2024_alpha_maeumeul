using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.XR;

public class DeleteTracker : MonoBehaviour
{
    private void OnEnable()
    {
        Component[] components = gameObject.GetComponents(typeof(MonoBehaviour));
        bool found = false;
        MonoBehaviour mbTrackingPose = null;
        foreach (Component component in components)
        {
            string name = component.ToString();
            MonoBehaviour mb = (MonoBehaviour)component;
            if (name.Contains("TrackedPoseDriver"))
            {
                mbTrackingPose = mb;
                found = true;
                break;
            }
        }
        if(found) Destroy(mbTrackingPose);
        var self = gameObject.GetComponent<DeleteTracker>();
        Destroy(self);
    }
}
