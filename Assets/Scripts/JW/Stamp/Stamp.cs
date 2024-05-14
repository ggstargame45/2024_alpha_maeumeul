using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Stamp : MonoBehaviour
{
    public float distance = 0.2f;
    bool canUse = true;

    public void Call()
    {
        if (!canUse) return;
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
        Debug.DrawRay(gameObject.transform.position, transform.up * -1 * distance, Color.red);
    }

    private IEnumerator Process()
    {
        var wfs = new WaitForSeconds(0.5f);
        yield return wfs;
        canUse = true;
        yield break;
    }
}
