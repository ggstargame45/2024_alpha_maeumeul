using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Stamp : MonoBehaviour
{
    private StampSign stampSign;
    public float distance = 0.2f;
    public LayerMask canStampLayer;

    public void Call()
    {
        if(Physics.Raycast(transform.position, transform.up * -1, out RaycastHit hitInfo, distance, canStampLayer))
        {
            stampSign = hitInfo.transform.Find("Stamp Sign").transform.GetComponent<StampSign>();
            if (stampSign.enabled)
                stampSign?.Stamped();
        }
        else
        {
            stampSign = null;
        }
    }

    private void Update()
    {
        Debug.DrawRay(transform.position, transform.up * -1 * distance, Color.red);
    }
}
