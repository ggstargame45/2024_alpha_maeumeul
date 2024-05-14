using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NoiseController : MonoBehaviour
{
    private CinemachineVirtualCamera target;
    private void Awake()
    {
        target = gameObject.GetComponent<CinemachineVirtualCamera>();
    }
    public void NoiseControl()
    {

    }
}
