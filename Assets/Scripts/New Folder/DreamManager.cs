using Autohand;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class DreamManager : MonoBehaviour
{
    public GameObject VRPlayer;
    private Rigidbody playerRigidBody;
    private AutoHandPlayer autoHandPlayer;


    public GameObject firstDreamFirstTask;
    public GameObject firstDreamSecondTask;



    public TestDoorOpen lastDoor;
    public TestDoorOpen endingDoor;

    public int firstDreamScoreCount = 0;


    public int lastDreamScoreCount = 0;


    private void Start()
    {
        playerRigidBody = VRPlayer.GetComponent<Rigidbody>();
        autoHandPlayer = VRPlayer.GetComponent<AutoHandPlayer>();

        startFirstDream();
        
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



    public void startEnding()
    {
        StopAllCoroutines();
        //Start the ending
    }




}
