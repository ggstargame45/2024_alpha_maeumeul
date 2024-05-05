using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using Autohand;

public class ForceCatch : MonoBehaviour
{ 
    private GameObject target;
    public UnityEvent catchEvents;

    private void OnTriggerEnter(Collider other)
    {
        target = other.gameObject;
        var grabInteractable = target.GetComponent<Grabbable>();

        if((grabInteractable == null) || !(target.tag == "CheckList"))
        {
            return;
        }

        target.transform.position = gameObject.transform.position;
        target.transform.rotation = gameObject.transform.rotation;

        catchEvents?.Invoke();

        Destroy(target.GetComponent<Grabbable>());
        Destroy(target.GetComponent<Rigidbody>());
        Destroy(target.GetComponent<BoxCollider>());
        Destroy(gameObject);
    }
}
