using Autohand;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Testscrasdfa : MonoBehaviour
{
    public void TestPlacingDebug(PlacePoint point, Grabbable grabbable)
    {
        Debug.Log("Placing " + grabbable.name + " at " + point.name);
    }
}
