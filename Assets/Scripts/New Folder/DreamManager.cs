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

    public List<GameObject> animationObjects;

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


    public void StartArrangeTaskUI()
    {
        if(usingUI)
        {
            return;
        }
        StartCoroutine(StartArrangeTaskUICoroutine());

    }

    IEnumerator StartArrangeTaskUICoroutine()
    {
        for(int i = 0; i<2; i++)
        {
            usingUI= true;
            UIimage.sprite = UIimages[i+6];
            UIimageObject.SetActive(true);
            yield return new WaitForSeconds(3.0f);
            UIimageObject.SetActive(false);
        }
        usingUI = false;
    }

    public void StartShootingTaskUI()
    {
        if(usingUI)
        {
            return;
        }
        StartCoroutine(StartShootingTaskUICoroutine());
    }

    IEnumerator StartShootingTaskUICoroutine()
    {
        usingUI = true;

            UIimage.sprite = UIimages[8];
            UIimageObject.SetActive(true);
            yield return new WaitForSeconds(3.0f);
            UIimageObject.SetActive(false);

    usingUI = false;
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
        Debug.Log("hi");
        if (animationObjects.Count != 0)
        {
            for (int i = 0; i < animationObjects.Count; i++)
            {
                yield return MoveTo(VRPlayer.transform, animationObjects[i + 1].transform, 30.0f);
                yield return null;
            }
        }

        yield return MoveTo(VRPlayer.transform, endingEndZone.transform, 30.0f);
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
