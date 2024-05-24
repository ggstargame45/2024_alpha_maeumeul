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


    private List<PlacePoint> placedPlacePoint;
    private List<GameObject> detachedIcons;

    public int startRedIconCount;
    private int currentRedIconCount;
    public int startBlueIconCount;
    private int currentBlueIconCount;
    public int startYellowIconCount;
    private int currentYellowIconCount;


    public int puzzleRound = 2; //0 : 4°³, 1 ; 9°³, 2< : 12°³
    public bool isAvailable = true;
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
        }
        for (int i = 0; i < blueIconParent.transform.childCount; i++)
        {
            blueIconObjectPrefabs.Add(blueIconParent.transform.GetChild(i).gameObject);
        }
        for (int i = 0; i < yellowIconParent.transform.childCount; i++)
        {
            yellowIconObjectPrefabs.Add(yellowIconParent.transform.GetChild(i).gameObject);
        }

        StartPuzzle();
    }

    public void StartPuzzle()
    {
        //if(!isAvailable)
        //{
        //    return;
        //}
        placedPlacePoint = new List<PlacePoint>();
        detachedIcons = new List<GameObject>();
        glowingZone.SetActive(true);
        isAvailable = true;

        startCurrentRound();
    }

    void startCurrentRound()
    {
        foreach(GameObject gameObject in redIconObjectPrefabs)
        {
            gameObject.SetActive(false);
        }
        foreach (GameObject gameObject in blueIconObjectPrefabs)
        {
            gameObject.SetActive(false);
        }
        foreach (GameObject gameObject in yellowIconObjectPrefabs)
        {
            gameObject.SetActive(false);
        }

        currentRedIconCount = 0;
        currentBlueIconCount = 0;
        currentYellowIconCount = 0;
        if (puzzleRound == 0)
        {
            startRedIconCount = 2;
            startBlueIconCount = 1;
            startYellowIconCount = 1;

            redIconObjectPrefabs[0].SetActive(true);
            blueIconObjectPrefabs[0].SetActive(true);
            redIconObjectPrefabs[1].SetActive(true);
            yellowIconObjectPrefabs[0].SetActive(true);

            greyPlacePoints[0].Place(redIconObjectPrefabs[0].GetComponent<Grabbable>());
            greyPlacePoints[1].Place(blueIconObjectPrefabs[1].GetComponent<Grabbable>());
            grey2PlacePoints[4].Place(redIconObjectPrefabs[1].GetComponent<Grabbable>());
            grey2PlacePoints[5].Place(yellowIconObjectPrefabs[0].GetComponent<Grabbable>());

            detachedIcons.Add(redIconObjectPrefabs[0]);
            detachedIcons.Add(blueIconObjectPrefabs[0]);
            detachedIcons.Add(redIconObjectPrefabs[1]);
            detachedIcons.Add(yellowIconObjectPrefabs[0]);

        }
        else if (puzzleRound == 1)
        {
            startRedIconCount = 3;
            startBlueIconCount = 3;
            startYellowIconCount = 3;

            for(int i = 0; i <2; i++)
            {
                redIconObjectPrefabs[i % 4].SetActive(true);
                blueIconObjectPrefabs[i % 4].SetActive(true);

                greyPlacePoints[i+5].Place(redIconObjectPrefabs[i%4].GetComponent<Grabbable>());
                grey2PlacePoints[i + 8].Place(yellowIconObjectPrefabs[i%4].GetComponent<Grabbable>());
                detachedIcons.Add(redIconObjectPrefabs[i % 4]);
                detachedIcons.Add(yellowIconObjectPrefabs[i % 4]);
            }
            for(int i =2; i <4; i++)
            {
                blueIconObjectPrefabs[i % 4].SetActive(true);
                if (i % 2 == 0)
                {
                    redIconObjectPrefabs[i % 4].SetActive(true);
                }
                else
                {
                    blueIconObjectPrefabs[(i + 1) % 4].SetActive(true);
                }
                greyPlacePoints[i + 5].Place(blueIconObjectPrefabs[i%4].GetComponent<Grabbable>());
                grey2PlacePoints[i + 8].Place(i%2==0 ? redIconObjectPrefabs[i%4].GetComponent<Grabbable>() : blueIconObjectPrefabs[(i+1) % 4].GetComponent<Grabbable>());
                detachedIcons.Add(blueIconObjectPrefabs[i % 4]);
                detachedIcons.Add(i % 2 == 0 ? redIconObjectPrefabs[i % 4] : blueIconObjectPrefabs[(i + 1) % 4]);
            }
            yellowIconObjectPrefabs[3 % 4].SetActive(true);
            greyPlacePoints[9].Place(yellowIconObjectPrefabs[3%4].GetComponent<Grabbable>());
            detachedIcons.Add(yellowIconObjectPrefabs[3 % 4]);

        }
        else
        {
            startRedIconCount = 4;
            startBlueIconCount = 4;
            startYellowIconCount = 4;

            for (int i =0; i<4; i++)
            {
                if(i%2 == 0)
                {
                    redIconObjectPrefabs[i%4].SetActive(true);
                    greyPlacePoints[i].Place(redIconObjectPrefabs[i % 4].GetComponent<Grabbable>());
                    detachedIcons.Add(redIconObjectPrefabs[i % 4]);
                }
                else
                {
                    blueIconObjectPrefabs[i % 4].SetActive(true);
                    greyPlacePoints[i].Place(blueIconObjectPrefabs[i % 4].GetComponent<Grabbable>());
                    detachedIcons.Add(blueIconObjectPrefabs[i % 4]);
                }
                
            }
            for(int i =4; i <8; i++)
            {
                if(i%2 == 0)
                {blueIconObjectPrefabs[i % 4].SetActive(true);
                    greyPlacePoints[i].Place(blueIconObjectPrefabs[i % 4].GetComponent<Grabbable>());
                    detachedIcons.Add(blueIconObjectPrefabs[i % 4]);
                }
                else
                {
                    yellowIconObjectPrefabs[i % 4].SetActive(true);
                    greyPlacePoints[i].Place(yellowIconObjectPrefabs[i % 4].GetComponent<Grabbable>());
                    detachedIcons.Add(yellowIconObjectPrefabs[i % 4]);
                }
            }
            for(int i =8; i <12; i++)
            {
                if(i%2 == 0)
                {
                    yellowIconObjectPrefabs[i % 4].SetActive(true);
                    grey2PlacePoints[i].Place(yellowIconObjectPrefabs[i % 4].GetComponent<Grabbable>());
                    detachedIcons.Add(yellowIconObjectPrefabs[i % 4]);
                }
                else
                {redIconObjectPrefabs[i % 4].SetActive(true);
                    grey2PlacePoints[i].Place(redIconObjectPrefabs[i % 4].GetComponent<Grabbable>());
                    detachedIcons.Add(redIconObjectPrefabs[i % 4]);
                }
            }


        }

    }

    public void stopEveryThing()
    {

    }

    public void taskSuccess()
    {
        puzzleSucceed.Invoke();
        glowingZone.SetActive(false);
        puzzleRound++;
        
        foreach (PlacePoint placePoint in placedPlacePoint)
        {
            placePoint.Remove();
           // Destroy(placePoint.gameObject);
        }
        foreach (GameObject gameObject in redIconObjectPrefabs)
        {
            gameObject.SetActive(false);
        }
        foreach (GameObject gameObject in blueIconObjectPrefabs)
        {
            gameObject.SetActive(false);
        }
        foreach (GameObject gameObject in yellowIconObjectPrefabs)
        {
            gameObject.SetActive(false);
        }

        detachedIcons.Clear();

        if(isFirst)
        {
            isFirst = false;
            ArrangeUI.SetActive(false);
        }
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
                placePoint.Remove();
            }
        }
        //put grabbable to detachedIconsParent child


        
        
    }
}
