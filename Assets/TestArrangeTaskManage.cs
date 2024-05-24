using Autohand;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Events;

public class TestArrangeTaskManage : MonoBehaviour
{

    public GameObject glowingZone;
    public GameObject windows;
        
    public UnityEvent puzzleSucceed;
    // Start is called before the first frame update

    //jpg->ppt->txt->mp4
    public List<GameObject> redIconObjectPrefabs;
    public List<GameObject> blueIconObjectPrefabs;
    public List<GameObject> yellowIconObjectPrefabs;


    private List<PlacePoint> placedPlacePoint;

    public GameObject detachedIconsParent;


    public int startRedIconCount;
    public int startBlueIconCount;
    public int startYellowIconCount;


    public int puzzleRound; //0 : 4°³, 1 ; 9°³, 2< : 12°³
    public bool isAvailable = false;
    public bool isInitializing = false;

    private void Start()
    {
        StartPuzzle();
    }

    public void StartPuzzle()
    {
        if(isAvailable)
        {
            return;
        }
        glowingZone.SetActive(true);
        isAvailable = true;
        
    }

    void startCurrentRound()
    {
        if (puzzleRound == 0)
        {
            startRedIconCount = 2;
            startBlueIconCount = 1;
            startYellowIconCount = 1;
        }
        else if (puzzleRound == 1)
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
    }

    public void somethingPlaced(PlacePoint placePoint, Grabbable grabbable)
    {
        if(placePoint.tag == grabbable.tag)
        {

        }
        
    }

    public void somethingRemoved(PlacePoint placePoint, Grabbable grabbable)
    {
        if(isInitializing)
        {

        }
        else
        {
            if (placePoint.tag == grabbable.tag)
            {

            }
        }
        //put grabbable to detachedIconsParent child

        
        
    }
}
