using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.InputSystem.LowLevel.InputStateHistory;
using UnityEngine.UIElements;

public class BallAction : MonoBehaviour
{
    public GameObject destination;

    private void Start() {
        //Call(); //TESTCODE
    }
    public void Call()
    {
        StopAllCoroutines();
        StartCoroutine(Progress());
    }

    private IEnumerator Progress()
    {
        float time = 1f;
        float wait = 0.01f;
        var wfs = new WaitForSeconds(wait);
        float now = 0f;
        Vector3 startPosition = gameObject.transform.position;
        while (now < time)
        {
            gameObject.transform.position = ((startPosition * (1 - (now / time))) + (destination.transform.position * (now / time)));
            now += wait;
            yield return wfs;
        }
        yield break;
    }
}
