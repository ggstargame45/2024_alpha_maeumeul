using Kandooz.Burger;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public class UIAppearDisappear : MonoBehaviour
{
    public GameObject head;
    public bool autoDisappear = false;
    private Image image;
    private void Awake()
    {
        image = gameObject.GetComponent<Image>();
        var color = image.color;
        color.a = 0f;
        image.color = color;
    }
    private void OnEnable()
    {
        StopAllCoroutines();
        StartCoroutine(Process(true));
    }

    public void Disappear()
    {
        StopAllCoroutines();
        StartCoroutine(Process(false));
    }

    private IEnumerator Process(bool isAppear)
    {
        float time = 0.5f;
        float now = 0f;
        float wait = 0.01f;
        var wfs = new WaitForSeconds(wait);
        int val = 1;
        if (!isAppear) val = -1;
        while(now < time)
        {
            var color = image.color;
            color.a += wait / time * val;
            image.color = color;
            now += wait;
            yield return wfs;
        }
        if (isAppear)
        {
            if (autoDisappear)
            {
                yield return new WaitForSeconds(5);
                Disappear();
            }
        }
        else
        {
            head?.SetActive(false);
        }
        yield break;
    }
}
