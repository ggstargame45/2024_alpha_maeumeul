using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestDoorOpen : MonoBehaviour
{
    public GameObject LeftDoor;
    public GameObject RightDoor;

    public RandomAudioPlayer doorAudio;

    private void Start()
    {
        
    }

    public void StartDoorOpen()
    {
        StartCoroutine(OpenDoor());
    }

    public void StartCloseDoor()
    {
        StartCoroutine(CloseDoor());
    }

    
    //Coroutine that rotates the object 180 degrees around the Y axis for a duration
    IEnumerator OpenDoor()
    {
        float duration = 5.0f;
        float elapsed = 0.0f;
        Vector3 leftStartRotation = LeftDoor.transform.rotation.eulerAngles;
        Vector3 leftEndRotation = leftStartRotation + new Vector3(0, 90, 0);
        Vector3 rightStartRotation = RightDoor.transform.rotation.eulerAngles;
        Vector3 rightEndRotation = rightStartRotation + new Vector3(0, -90, 0);


        if(doorAudio != null)
        {
            doorAudio.setStartTime(1.0f);
            doorAudio.PlayRandomClip();
        }


        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            LeftDoor.transform.rotation = Quaternion.Euler(Vector3.Lerp(leftStartRotation, leftEndRotation, elapsed / duration));
            RightDoor.transform.rotation = Quaternion.Euler(Vector3.Lerp(rightStartRotation, rightEndRotation, elapsed / duration));
            yield return null;
        }

        doorAudio.Stop();
    }

    IEnumerator CloseDoor()
    {
        float duration = 3.0f;
        float elapsed = 0.0f;
        Vector3 leftStartRotation = LeftDoor.transform.rotation.eulerAngles;
        Vector3 leftEndRotation = leftStartRotation + new Vector3(0, -90, 0);
        Vector3 rightStartRotation = RightDoor.transform.rotation.eulerAngles;
        Vector3 rightEndRotation = rightStartRotation + new Vector3(0, 90, 0);

        if (doorAudio != null)
        {
            doorAudio.setStartTime(1.0f);
            doorAudio.PlayRandomClip();
        }


        while (elapsed < duration)
        {
            elapsed += Time.deltaTime;
            LeftDoor.transform.rotation = Quaternion.Euler(Vector3.Lerp(leftStartRotation, leftEndRotation, elapsed / duration));
            RightDoor.transform.rotation = Quaternion.Euler(Vector3.Lerp(rightStartRotation, rightEndRotation, elapsed / duration));
            yield return null;
        }

        doorAudio.Stop();
        
    }
    
}
