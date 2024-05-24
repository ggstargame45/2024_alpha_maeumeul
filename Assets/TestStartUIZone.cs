using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestStartUIZone : MonoBehaviour
{
    public void deactivateOnFirstSuccess()
    {
        gameObject.SetActive(false);
    }
}
