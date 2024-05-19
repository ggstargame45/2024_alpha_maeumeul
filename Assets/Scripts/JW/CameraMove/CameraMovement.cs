using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMovement : MonoBehaviour
{
    public float plusY = 0.2f;
    public float time = 1f;
    public int repeat = 1;

    public void Call()
    {
        StopAllCoroutines();
        StartCoroutine(Process(plusY, time, repeat));
    }

    private IEnumerator Process(float y, float time, int repeat = 1)
    {
        var startY = gameObject.transform.position.y;
        gameObject.GetComponent<CinemachineVirtualCamera>().Follow = null;
        gameObject.GetComponent<CinemachineVirtualCamera>().LookAt = null;
        float wait = 0.01f;
        float now = 0;
        var wfs = new WaitForSeconds(wait);
        var t = time / 2;
        for (int i = 0; i < repeat; i++)
        {
            while (now < t)
            {
                var nowY = (startY * (1 - (now / t))) + ((startY + y) * now / t);
                gameObject.transform.position = new Vector3(gameObject.transform.position.x, nowY, gameObject.transform.position.z);
                now += wait;
                yield return wfs;
            }
            while (now > 0)
            {
                var nowY = (startY * (1 - (now / t))) + ((startY + y) * now / t);
                gameObject.transform.position = new Vector3(gameObject.transform.position.x, nowY, gameObject.transform.position.z);
                now -= wait;
                yield return wfs;
            }
        }
        yield break;
    }
}
