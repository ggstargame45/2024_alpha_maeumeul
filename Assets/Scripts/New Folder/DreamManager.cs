using Autohand;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

public class DreamManager : MonoBehaviour
{
    public GameObject VRPlayer;
    private Rigidbody playerRigidBody;
    private AutoHandPlayer autoHandPlayer;


    public GameObject firstDreamFirstTask;
    public GameObject firstDreamSecondTask;

    public GameObject endingStartZone;
    public GameObject endingEndZone;

    public TestDoorOpen lastDoor;
    public TestDoorOpen endingDoor;

    public Image UIimage;
    public GameObject UIimageObject;

    public List<Sprite> UIimages;

    public int firstDreamScoreCount = 0;


    public int lastDreamScoreCount = 0;


    private void Start()
    {
        playerRigidBody = VRPlayer.GetComponent<Rigidbody>();
        autoHandPlayer = VRPlayer.GetComponent<AutoHandPlayer>();

        startFirstDream();



        
    }

    //fadein corutine
    IEnumerable FadeIn()
    {
        yield return null;
    }
    //fadeout corutine
    IEnumerable FadeOut()
    {
        yield return null;
    }

    public void startFirstDream()
    {
        //Start the first dream coroutine
        StartCoroutine(FirstDream());
    }

    public void incrementScore()
    {
        firstDreamScoreCount++;
    }


    IEnumerator FirstDream()
    {
        //Do something
        while(firstDreamScoreCount < 4) { 
            yield return null;
        }

        yield return new WaitForSeconds(Random.Range(4.0f, 7.0f));

        lastDoor.StartDoorOpen();

    }


    public void startLastDream()
    {
        StopAllCoroutines();

        lastDoor.StartCloseDoor();
        //Start the last dream

        
    }

    IEnumerator LastDream()
    {
        while (lastDreamScoreCount < 4)
        {
            yield return null;
        }

        yield return new WaitForSeconds(Random.Range(4.0f, 7.0f));

        endingDoor.StartDoorOpen();
    }



    public void startEnding()
    {
        StopAllCoroutines();

        endingDoor.StartCloseDoor();

        autoHandPlayer.useMovement = false;
        autoHandPlayer.useGrounding = false;
        playerRigidBody.useGravity = false;
        playerRigidBody.isKinematic = true;
        //Start the ending

        StartCoroutine(Ending());

    }

    //ending coroutine
    IEnumerator Ending()
    {
        while (true)
        {
            yield return null;
        }
    }

    public void endingFinish()
    {

    }


    //A corutine that goes from one point to another
    IEnumerator MoveTo(Transform start, Transform end, float time)
    {
        float elapsedTime = 0;
        Vector3 startingPos = start.position;
        Vector3 endingPos = end.position;

        while (elapsedTime < time)
        {
            start.position = Vector3.Lerp(startingPos, endingPos, (elapsedTime / time));
            elapsedTime += Time.deltaTime;
            yield return null;
        }
        start.position = endingPos;
    }

    //





}
