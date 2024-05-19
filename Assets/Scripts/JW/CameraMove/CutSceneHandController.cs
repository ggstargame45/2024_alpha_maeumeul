using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UIElements;

public class CutSceneHandController : MonoBehaviour
{
    public void GotoSleep()
    {
        StopAllCoroutines();
        StartCoroutine(Process(2f, new Vector3(0.34f, 0.872f, 0.247f), new Vector3(0f, 57.8f, -90.583f)));
    }

    private IEnumerator Process(float second, Vector3 pos, Vector3 rot)
    {
        float wait = 0.01f;
        var wfs = new WaitForSeconds(wait);
        float now = 0f;
        Vector3 startPosition = gameObject.transform.position;
        Vector3 startRotation = gameObject.transform.rotation.eulerAngles;
        while(now < second)
        {
            gameObject.transform.localPosition = (startPosition * (1 - (now / second))) + (pos * (now / second));
            gameObject.transform.localEulerAngles = (startRotation * (1 - (now / second)) + (rot * (now / second)));
            now += wait;
            yield return wfs;
        }
        yield break;
    }
}
