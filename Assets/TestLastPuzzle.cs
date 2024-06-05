using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestLastPuzzle : MonoBehaviour
{
    public List<GameObject> rbandcolParent;

    public List<Rigidbody> rb;
    public List<Collider> col;
    public bool isRotating = false;
    public int index;
    public UnityEvent Ended;
    public UnityEvent firstHit;
    public bool needFlip;

    public int hitCount = 0;

    public void startEnd()
    {
        foreach(GameObject gameObject in rbandcolParent)
        {
            for(int i =0; i< gameObject.transform.childCount; i++)
            {
                if (gameObject.transform.GetChild(i).GetComponent<Rigidbody>() != null)
                {
                    rb.Add(gameObject.transform.GetChild(i).GetComponent<Rigidbody>());
                }
                if (gameObject.transform.GetChild(i).GetComponent<Collider>() != null)
                {
                    col.Add(gameObject.transform.GetChild(i).GetComponent<Collider>());
                }
            }
            {
                
            }
        }

        StartCoroutine(startEndCorutine());
    }

    public IEnumerator startEndCorutine()
    {
        yield return new WaitForSeconds(1);

        foreach (Rigidbody r in rb)
        {
            r.isKinematic = false;
            r.useGravity = true;
        }
        foreach (Collider c in col)
        {
            c.isTrigger = false;
        }

        Ended.Invoke();

    }

    public void SetAnswer(bool answer)
    {
        needFlip = answer;
        if (answer)
        {
            transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles + new Vector3(180, 0, 0));
        }
    }



    public void Hit()
    {
        if(hitCount == 0)
        {
            firstHit.Invoke();
            
        }
        hitCount++;

        if (hitCount > 15)
        {
            startEnd();
        }

        //StartCoroutine(Rotate180());
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


}
