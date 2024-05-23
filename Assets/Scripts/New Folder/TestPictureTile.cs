using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestPictureTile : MonoBehaviour
{

    public bool isRotating = false;
    void Start()
    {
        //StartCoroutine(Rotate180Random());
        
    }

    public void StartRotation()
    {
        StartCoroutine(Rotate180());
    }


    //Coroutine that rotates the object 180 degrees around the Y axis for a duration
    IEnumerator Rotate180()
    {
        float duration = 1.0f;
        float elapsed = 0.0f;
        Vector3 startRotation = transform.rotation.eulerAngles;
        Vector3 endRotation = startRotation + new Vector3(180, 0, 0);

        isRotating = true;

        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            transform.rotation = Quaternion.Euler(Vector3.Lerp(startRotation, endRotation, elapsed / duration));
            yield return null;
        }

        transform.rotation = Quaternion.Euler(endRotation);
        isRotating = false;

       
    }

    //A coroutine that executes Rotate180() wait a random amount of time between 1 and 3 seconds, then executes Rotate180() again, and so on
    IEnumerator Rotate180Random()
    {
        while (true)
        {
            yield return Rotate180();
            yield return new WaitForSeconds(Random.Range(1.0f, 3.0f));
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (!isRotating && other.tag=="Bullet")
        {
            StartCoroutine(Rotate180());
            
        }
    }


}
