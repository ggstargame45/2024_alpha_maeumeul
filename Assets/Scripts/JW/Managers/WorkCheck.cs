using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;
using UnityEngine.Events;

public class WorkCheck : MonoBehaviour
{
    [Space]
    public GameObject cleanWork;
    [Space]
    public GameObject[] cleanGrab;
    public UnityEvent cleanGrabEvent;
    public GameObject[] firstClean;
    public UnityEvent firstCleanEvent;
    public GameObject[] lastClean;
    public UnityEvent lastCleanEvent;
    [Space]
    [Space]
    public GameObject stampWork;
    [Space]
    public GameObject[] stampGrab;
    public UnityEvent stampGrabEvent;
    public GameObject[] firstStamp;
    public UnityEvent firstStampEvent;

    private void Start()
    {
        if (cleanWork)
        {
            var target = cleanWork.GetComponent<WorkHelper>();
            target.firstGrab -= RingbinderGrab;
            target.firstGrab += RingbinderGrab;
            target.firstWork -= FirstRingbinderClean;
            target.firstWork += FirstRingbinderClean;
            target.lastWork -= LastRingbinderClean;
            target.lastWork += LastRingbinderClean;
        }
        if (stampWork)
        {
            var target = stampWork.GetComponent<WorkHelper>();
            target.firstGrab -= StampGrab;
            target.firstGrab += StampGrab;
            target.firstWork -= FirstStamp;
            target.firstWork += FirstStamp;
        }
    }

    private void ImagePlay(GameObject[] gameObjects)
    {
        for(int i = 0; i < gameObjects.Length; i++)
        {
            gameObjects[i].GetComponent<SequenceImagePlayer>().Call();
        }
    }
    private void RingbinderGrab()
    {
        ImagePlay(cleanGrab);
        cleanGrabEvent?.Invoke();
    }

    private void FirstRingbinderClean()
    {
        ImagePlay(firstClean);
        firstCleanEvent?.Invoke();
    }

    private void LastRingbinderClean()
    {
        ImagePlay(lastClean);
        lastCleanEvent?.Invoke();
    }

    private void StampGrab()
    {
        ImagePlay(stampGrab);
        stampGrabEvent?.Invoke();
    }

    private void FirstStamp()
    {
        ImagePlay(firstStamp);
        firstStampEvent?.Invoke();
    }
}
