using Autohand;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AutoHandSocketInteractable : MonoBehaviour
{
    public bool canInteract = true;
    public string socketInteractionTag = "default";
    private bool isGrabbed = false;
    private bool isSelected = false;
    private Rigidbody rigid;

    private void Awake()
    {
        rigid = gameObject.GetComponent<Rigidbody>();
    }
    public bool IsGrabbed
    {
        get { return isGrabbed; }
    }

    public bool IsSelected
    {
        get { return isSelected; }
    }
    public void GrabEnter()
    {
        isGrabbed = true;
    }
    public void GrabExit()
    {
        isGrabbed = false;
    }

    /*
    public void ItemSelectEnter() {
        isSelected = true;
        rigid.useGravity = false;
        rigid.isKinematic = true;
    }

    public void ItemSelectExited()
    {
        isSelected = false;
        rigid.useGravity = true;
        rigid.isKinematic = false;
    }
    */
    private void OnTriggerExit(Collider other)
    {
        var check = other.gameObject.GetComponent<AutoHandSocketInteratcor>();
        if (check == null)
        {
            return;
        }
        var target = gameObject.GetComponent<Rigidbody>();
        target.useGravity = true;
        target.isKinematic = false;
    }
}
