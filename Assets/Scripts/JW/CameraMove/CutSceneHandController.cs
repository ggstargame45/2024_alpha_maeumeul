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
        StartCoroutine(Process(1.5f, new Vector3(0.34f, 0.872f, 0.247f), true, new Vector3(0f, 57.8f, -90.583f)));
    }

    public void HandUp()
    {
        StopAllCoroutines();
        StartCoroutine(Process(0.5f, new Vector3(-0.005f,1f,0.284f), true, new Vector3(0f, 16.5f, -90.583f)));
    }

    public void Smash()
    {
        StopAllCoroutines();
        StartCoroutine(Process(0.1f, new Vector3(-0.005f, 0.898f, 0.284f), false));
    }

    private IEnumerator Process(float second, Vector3 pos, bool isAngle, Vector3 rot = new Vector3())
    {
        float wait = 0.02f;
        var wfs = new WaitForSeconds(wait);
        float now = 0f;
        Vector3 startPosition = gameObject.transform.localPosition;
        Vector3 startRotation = gameObject.transform.localRotation.eulerAngles;
        Vector3 velocity = Vector3.zero;
        while(now < second)
        {
            gameObject.transform.localPosition = (startPosition * (1 - (now / second))) + (pos * (now / second));
            if (isAngle)
            {
                gameObject.transform.localEulerAngles = (startRotation * (1 - (now / second)) + (rot * (now / second)));
            }
            now += wait;
            yield return wfs;
        }
        yield break;
    }
}
