using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Stamp : MonoBehaviour
{
    public UnityEvent stampEvent;
    public float distance = 0.2f;
    bool canUse = true;

    public void Call()
    {
        if (!canUse) return;
        stampEvent?.Invoke();
        if (!StampAngleCheck()) return;
        canUse = false;
        RaycastHit[] hits;
        hits = Physics.RaycastAll(gameObject.transform.position, transform.up * -1, distance);
        for (int i = 0; i < hits.Length; i++)
        {
            Debug.Log(hits[i].transform.name);
            var stampSign = hits[i].transform.GetComponent<StampSign>();
            if (stampSign)
                if (stampSign.enabled)
                    stampSign?.Stamped();
        }
        StopAllCoroutines();
        StartCoroutine(Process());
    }

    private void Update()
    {
        //Debug.DrawRay(gameObject.transform.position, transform.up * -1 * distance, Color.red);
    }

    private bool StampAngleCheck()
    {
        var yAngle = Mathf.Abs(gameObject.transform.rotation.eulerAngles.y);
        yAngle %= 180f;
        if (yAngle <= 10f || yAngle >= 170f)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    private IEnumerator Process()
    {
        var wfs = new WaitForSeconds(0.5f);
        yield return wfs;
        canUse = true;
        yield break;
    }
}
