using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class TestUIObject : MonoBehaviour
{


    //When this becomes enabled, start the fade in coroutine

    private void OnEnable()
    {
        StartCoroutine(FadeIn());
    }

    //fadein corutine
    IEnumerator FadeIn()
    {
        //wait for 1 second
        yield return new WaitForSeconds(5);
        
        gameObject.SetActive(false);
    }
    
}
