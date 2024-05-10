using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UIElements;

public class CutSceneHandController : MonoBehaviour
{
    public GameObject rightHand;
    public UnityEvent pencilCase;
    public void GotoPencilCase()
    {
        StopAllCoroutines();
        StartCoroutine(Process(0.3f, new Vector3(-0.056f, 0.866f, 0.541f), new Vector3(0f, 0f, 0f), pencilCase));
    }

    private IEnumerator Process(float second, Vector3 position, Vector3 rotation, UnityEvent action)
    {
        float wait = 0.01f;
        var wfs = new WaitForSeconds(wait);
        float now = 0;
        Vector3 startPosition = rightHand.transform.position;
        Vector3 startRotation = rightHand.transform.rotation.eulerAngles;
        while(now < second)
        {
            rightHand.transform.position = ((startPosition * (1 - (now / second))) + (position * (now / second)));
            rightHand.transform.localEulerAngles = (startRotation * ((1 - now) / second) + (rotation * (now / second)) / 2);
            now += wait;
            yield return wfs;
        }
        action?.Invoke();
        yield break;
    }
}
