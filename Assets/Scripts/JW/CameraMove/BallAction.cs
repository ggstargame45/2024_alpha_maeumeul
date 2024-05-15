using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallAction : MonoBehaviour
{
    public GameObject ball;

    public void Call()
    {
        StopAllCoroutines();
        StartCoroutine(Progress());
    }

    private IEnumerator Progress()
    {
        float time = 1f;
        var wfs = new WaitForSeconds(0.01f);

        yield break;
    }
}
