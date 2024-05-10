using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Events;

public class AutoHandSocketInteratcor : MonoBehaviour
{
    [Header("Setting")]
    public string socketInteractionTag = "default";
    public Transform attachTransform = null;
    [Space]

    [Header("Hover Interaction")]
    public UnityEvent HoverEntered;
    public UnityEvent HoverExited;
    [Header("Select Interacion")]
    public UnityEvent SelectEntered;
    public UnityEvent SelectExited;

    private bool isHover = false;
    private bool isSelected = false;
    private GameObject target;
    private AutoHandSocketInteractable socketItem;

    private void Awake()
    {
        if(!attachTransform)
        {
            attachTransform = gameObject.transform;
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (isHover == true) return;
        target = other.gameObject;
        socketItem = target.GetComponent<AutoHandSocketInteractable>();
        if (socketItem != null)
        {
            if (socketItem.canInteract == true && socketInteractionTag.Equals(socketItem.socketInteractionTag))
            {
                HoverEnter();
            }
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (isHover)
        {
            if (target == null || socketItem == null)
            {
                Debug.Log("target object is missing");
                HoverExit();
                return;
            }

            if (isSelected == false)
            {
                if(socketItem.IsGrabbed == false)
                {
                    Select();
                }
            }
            else
            {
                Follow();

                if(socketItem.IsGrabbed == true)
                {
                    DeSelect();
                }
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        HoverExit();
    }

    private void HoverEnter()
    {
        isHover = true;
        HoverEntered?.Invoke();
    }

    private void HoverExit()
    {
        isHover = false;
        isSelected = false;
        target = null;
        socketItem = null;
        HoverExited?.Invoke();
    }

    private void Select()
    {
        isSelected = true;
        var rigid = target.GetComponent<Rigidbody>();
        rigid.useGravity = false;
        //rigid.isKinematic = true;
        Follow();
        SelectEntered?.Invoke();
    }

    private void Follow()
    {
        target.transform.position = attachTransform.position;
        target.transform.rotation = attachTransform.rotation;
    }

    private void DeSelect()
    {
        isSelected = false;
        var rigid = target.GetComponent<Rigidbody>();
        rigid.useGravity = true;
        //rigid.isKinematic = false;
        SelectExited?.Invoke();
    }

    /*private void Update()
    {
        if (isHover)
        {
            if (target == null || socketItem == null)
            {
                Debug.Log("target object is missing");
                HoverExit();
                return;
            }

            if (isSelected == false)
            {
                if (socketItem.IsGrabbed == false)
                {
                    Select();
                    return;
                }
            }

            if (isSelected)
            {
                Follow();

                if (socketItem.IsGrabbed == true)
                {
                    DeSelect();
                }
            }
        }
    }*/
}
