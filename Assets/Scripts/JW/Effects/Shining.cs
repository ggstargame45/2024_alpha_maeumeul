using System.Collections;
using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using UnityEngine.Events;

public class Shining : MonoBehaviour
{
    public UnityEvent awakeEvent;
    public Color shiningColor;
    private Renderer target;

    private void Awake()
    {
        target = GetComponent<Renderer>();
        awakeEvent?.Invoke();
    }

    public void On()
    {
        StopAllCoroutines();
        StartCoroutine(Process());
    }

    public void Off()
    {
        StopAllCoroutines();
    }

    private IEnumerator Process()
    {
        var wff = new WaitForEndOfFrame();
        if(target == null)
        {
            yield break;
        }
        float angle = 0f;
        while (true)
        {
            var ratio = Mathf.Abs(Mathf.Cos(angle * Mathf.Deg2Rad));
            //var color = baseColor * ratio + shiningColor * (1 - ratio);
            target.material.color = new Color(0, 0, 0, ratio);
            target.material.SetColor("_EmissionColor", shiningColor);
            angle += 0.1f;
            angle %= 360;
            yield return wff;
        }
    }

}
