using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestGunPositionReset : MonoBehaviour
{
    public GameObject gun;

    public Vector3 firstPostion;

    public Vector3 lastPosition;

    public void GoToLastPosition()
    {
        this.transform.position = lastPosition;
        gun.transform.localPosition = Vector3.zero;
        gun.transform.localRotation = Quaternion.identity;
        gun.GetComponent<Rigidbody>().velocity = Vector3.zero;
        gun.GetComponent<Rigidbody>().angularVelocity = Vector3.zero;
    }


    public void GoToLocalZero()
    {
        gun.transform.localPosition = Vector3.zero;
        gun.transform.localRotation = Quaternion.identity;
        gun.GetComponent<Rigidbody>().velocity = Vector3.zero;
        gun.GetComponent<Rigidbody>().angularVelocity = Vector3.zero;

    }

}
