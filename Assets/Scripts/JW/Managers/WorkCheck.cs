using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;

public class WorkCheck : MonoBehaviour
{
    [Space]
    public GameObject cleanWork;
    [Space]
    public GameObject[] cleanGrab;
    public GameObject[] firstClean;
    public GameObject[] lastClean;
    [Space]
    [Space]
    public GameObject stampWork;
    [Space]
    public GameObject[] stampGrab;
    public GameObject[] firstStamp;

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
    }

    private void FirstRingbinderClean()
    {
        ImagePlay(firstClean);
    }

    private void LastRingbinderClean()
    {
        ImagePlay(lastClean);
    }

    private void StampGrab()
    {
        ImagePlay(stampGrab);
    }

    private void FirstStamp()
    {
        ImagePlay(firstStamp);
    }
}
