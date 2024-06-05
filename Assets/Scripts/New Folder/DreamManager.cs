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

    public List<GameObject> animationObjects;

    public UnityEvent firstDreamEndEvent;
    public UnityEvent lastDreamEndEvent;

    public UnityEvent lastDreamStartEvent;

    public UnityEvent endingStartEvent;

    public UnityEvent endingEndEvent;


    public int firstDreamScoreCount = 0;


    public int lastDreamScoreCount = 0;

    private bool usingUI = false;
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

    public void incrementFirstDreamScore()
    {
        firstDreamScoreCount++;
    }

    IEnumerator FirstDream()
    {
        //Do something
        while(firstDreamScoreCount < 5) { 
            yield return null;
        }

        yield return new WaitForSeconds(Random.Range(4.0f, 7.0f));

        lastDoor.StartDoorOpen();

    }


    public void startLastDream()
    {
        StopAllCoroutines();

        firstDreamEndEvent.Invoke();

        lastDoor.StartCloseDoor();
        //Start the last dream

        //StartCoroutine(LastDream());
        
    }


    public void lastDreamFinish()
    {
        lastDreamEndEvent.Invoke();
    }



    public void startEnding()
    {
        StopAllCoroutines();

        endingDoor.StartCloseDoor();

        //autoHandPlayer.useMovement = false;
        autoHandPlayer.maxMoveSpeed = 0;
        autoHandPlayer.smoothTurnSpeed = 0;
        autoHandPlayer.useGrounding = false;
        playerRigidBody.useGravity = false;
        //Start the ending

        StartCoroutine(Ending());

    }

    //ending coroutine
    IEnumerator Ending()
    {
        yield return MoveTo(VRPlayer.transform, new Vector3(0.0199999996f, 4.28606367f, 54.2099991f),5);
        StartCoroutine( MoveTo(VRPlayer.transform, endingEndZone.transform.position, 40.0f));
        if (animationObjects.Count != 0)
        {
            for (int i = 0; i < animationObjects.Count; i++)
            {
                animationObjects[i].SetActive(true);
                yield return new WaitForSeconds(5);
            }
        }

        endingEndEvent.Invoke();
    }

    public void endingFinish()
    {

    }


    //A corutine that goes from one point to another
    IEnumerator MoveTo(Transform start, Vector3 end, float time)
    {
        float elapsedTime = 0;
        Vector3 startingPos = start.position;
        Vector3 endingPos = end;

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
