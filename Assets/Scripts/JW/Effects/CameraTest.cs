using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTest : MonoBehaviour
{
    public GameObject vr;
    public GameObject ca;
    public float waitSeconds = 3f;

    private void Awake()
    {
        StartCoroutine(cutScene());
    }

    private IEnumerator cutScene()
    {
        var wait =  new WaitForSeconds(waitSeconds);
        yield return wait;
        vr.SetActive(false);
        ca.SetActive(true);
        yield break;
    }
}
