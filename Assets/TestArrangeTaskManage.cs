using Autohand;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Events;

public class TestArrangeTaskManage : MonoBehaviour
{

    public GameObject glowingZone;
    public GameObject ArrangeUI;
    public GameObject windows;
        
    public UnityEvent puzzleSucceed;
    public AudioSource successAudioSource;
    // Start is called before the first frame update

    //jpg->ppt->txt->mp4
    public List<GameObject> redIconObjectPrefabs;
    public List<GameObject> blueIconObjectPrefabs;
    public List<GameObject> yellowIconObjectPrefabs;

    public List<PlacePoint> greyPlacePoints;
    public List<PlacePoint> grey2PlacePoints;

    public GameObject greyPlacePointParent;
    public GameObject grey2PlacePointParent;
    public GameObject redIconParent;
    public GameObject blueIconParent;
    public GameObject yellowIconParent;


    public List<PlacePoint> placedPlacePoint;
    public List<GameObject> detachedIcons;

    public int startRedIconCount;
    public int currentRedIconCount;
    public int startBlueIconCount;
    public int currentBlueIconCount;
    public int startYellowIconCount;
    public int currentYellowIconCount;


    public int puzzleRound = 2; //0 : 4°³, 1 ; 9°³, 2< : 12°³
    public bool isAvailable = false;
    public bool isInitializing = false;
    public bool isFirst = true;

    private void Start()
    {
        for(int i = 0; i < grey2PlacePointParent.transform.childCount; i++)
        {
            grey2PlacePoints.Add(grey2PlacePointParent.transform.GetChild(i).GetComponent<PlacePoint>());  
        }
        for (int i = 0; i < greyPlacePointParent.transform.childCount; i++)
        {
            greyPlacePoints.Add(greyPlacePointParent.transform.GetChild(i).GetComponent<PlacePoint>());
        }
        for (int i = 0; i< redIconParent.transform.childCount; i++)
        {
            redIconObjectPrefabs.Add(redIconParent.transform.GetChild(i).gameObject);
            redIconObjectPrefabs[i].SetActive(false);
        }
        for (int i = 0; i < blueIconParent.transform.childCount; i++)
        {
            blueIconObjectPrefabs.Add(blueIconParent.transform.GetChild(i).gameObject);
            blueIconObjectPrefabs[i].SetActive(false);
        }
        for (int i = 0; i < yellowIconParent.transform.childCount; i++)
        {
            yellowIconObjectPrefabs.Add(yellowIconParent.transform.GetChild(i).gameObject);
            yellowIconObjectPrefabs[i].SetActive(false);
        }

        StartPuzzle();
    }

    public void StartPuzzle()
    {
        if (isAvailable)
        {
            return;
        }
        placedPlacePoint = new List<PlacePoint>();
        detachedIcons = new List<GameObject>();
        glowingZone.SetActive(true);
        isAvailable = true;

        startCurrentRound();
    }

    void startCurrentRound()
    {
        isInitializing = true;
        if (puzzleRound == 0)
        {
            startRedIconCount = 2;
            startBlueIconCount = 1;
            startYellowIconCount = 1;

        }
        else if(puzzleRound == 1)
        {
            startRedIconCount = 3;
            startBlueIconCount = 3;
            startYellowIconCount = 3;

        }
        else
        {
            startRedIconCount = 4;
            startBlueIconCount = 4;
            startYellowIconCount = 4;

        }
        for (int i = 0; i < startRedIconCount; i++)
        {
            detachedIcons.Add(Instantiate(redIconObjectPrefabs[Random.Range(0, 4)]));
            
        }
        for (int i = 0; i < startBlueIconCount; i++)
        {
            detachedIcons.Add(Instantiate(blueIconObjectPrefabs[Random.Range(0, 4)]));
        }
        for (int i = 0; i < startYellowIconCount; i++)
        {
            detachedIcons.Add(Instantiate(yellowIconObjectPrefabs[Random.Range(0, 4)]));
        }

        for(int i = 0; i<(startRedIconCount+startBlueIconCount+startYellowIconCount)/2; i++)
        {
            detachedIcons[i].SetActive(true);
            greyPlacePoints[i].Place(detachedIcons[i].GetComponent<Grabbable>());

        }
        for (int i = (startRedIconCount + startBlueIconCount + startYellowIconCount) / 2; i < (startRedIconCount + startBlueIconCount + startYellowIconCount); i++)
        {
            detachedIcons[i].SetActive(true);
            grey2PlacePoints[i].Place(detachedIcons[i].GetComponent<Grabbable>());
        }
        isInitializing = false;
    }

    public void stopEveryThing()
    {

    }

    public void taskSuccess()
    {
        isInitializing = true;
        puzzleSucceed.Invoke();
        glowingZone.SetActive(false);
        puzzleRound++;


        successAudioSource.Play();

        foreach (GameObject gameObject in detachedIcons)
        {
            Destroy(gameObject);
        }

        detachedIcons.Clear();
        isAvailable = false;

        if (isFirst)
        {
            isFirst = false;
            ArrangeUI.SetActive(false);
        }
        isInitializing = false;
    }

    public void checkSuccess()
    {
        if(currentRedIconCount == startRedIconCount && currentBlueIconCount == startBlueIconCount && currentYellowIconCount == startYellowIconCount)
        {
            taskSuccess();
        }
    }

    public void somethingPlaced(PlacePoint placePoint, Grabbable grabbable)
    {
        Debug.Log("Placing " + grabbable.name + " at " + placePoint.name);
        if(placePoint.tag == grabbable.tag)
        {
            if(placePoint.tag == "Red")
            {
                currentRedIconCount++;
            }
            else if(placePoint.tag == "Blue")
            {
                currentBlueIconCount++;
            }
            else if(placePoint.tag == "Yellow")
            {
                currentYellowIconCount++;
            }

            placedPlacePoint.Add(placePoint);
            checkSuccess();
        }
        
    }

    public void somethingRemoved(PlacePoint placePoint, Grabbable grabbable)
    {
        Debug.Log("Removing " + grabbable.name + " at " + placePoint.name);
        if(isInitializing)
        {

        }
        else
        {
            if (placePoint.tag == grabbable.tag)
            {
                if (placePoint.tag == "Red")
                {
                    currentRedIconCount--;
                }
                else if (placePoint.tag == "Blue")
                {
                    currentBlueIconCount--;
                }
                else if (placePoint.tag == "Yellow")
                {
                    currentYellowIconCount--;
                }
            }
        }
        //put grabbable to detachedIconsParent child

    }
}
