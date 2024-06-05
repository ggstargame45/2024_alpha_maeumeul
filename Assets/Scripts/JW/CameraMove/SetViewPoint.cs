using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetViewPoint : MonoBehaviour
{
    private CinemachineVirtualCamera virtualCamera;
    public GameObject go;

    private void Awake()
    {
        virtualCamera = gameObject.GetComponent<CinemachineVirtualCamera>();
    }

    public void Focus()
    {
        virtualCamera.LookAt = go.transform;
    }
}
