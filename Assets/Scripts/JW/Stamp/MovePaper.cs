using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class MovePaper : MonoBehaviour
{
    public float waitSeconds = 1f;
    [Space]
    public GameObject paper1;
    public Transform place1;
    public UnityEvent event1;
    [Space]
    public GameObject paper2;
    public Transform place2;
    public UnityEvent event2;

    public void move1()
    {
        StopAllCoroutines();
        StartCoroutine(Process(paper1, place1, event1));
    }

    public void move2()
    {
        StopAllCoroutines();
        StartCoroutine(Process(paper2, place2, event2));
    }

    public IEnumerator Process(GameObject go, Transform target, UnityEvent unityEvent)
    {
        yield return new WaitForSeconds(waitSeconds);
        var wfs = new WaitForSeconds(0.01f);
        float time = 1.0f, now = 0f;
        Vector3 position = go.transform.position;
        while(now < time)
        {
            go.transform.position = (go.transform.position * (1 - (now / time))) + target.position * now / time;
            now += 0.01f;
            yield return wfs;
        }
        unityEvent?.Invoke();
        yield break;
    }
}
