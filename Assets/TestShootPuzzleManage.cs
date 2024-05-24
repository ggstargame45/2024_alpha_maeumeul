using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestShootPuzzleManage : MonoBehaviour
{
    public List<GameObject> puzzlesGameObject;
    private List<TestIndivShootPuzzle> puzzles;

    public UnityEvent puzzleSucceed;

    public GameObject glowingZone;
    public GameObject ShootingUI;

    public int puzzleIndex;
    public bool isFirst = true;
    public bool isAvailable = true;

    public void Start()
    {
        puzzles = new List<TestIndivShootPuzzle>();
        foreach (GameObject puzzle in puzzlesGameObject)
        {
            puzzles.Add(puzzle.GetComponent<TestIndivShootPuzzle>());
        }
        StartPuzzle();
    }

    public void StartPuzzle()
    {
        //if(!isAvailable)
        //{
        //    return;
        //}
        Debug.Log("StartPuzzle");
        glowingZone.SetActive(true);
        isAvailable = true;
        puzzlesGameObject[puzzleIndex].SetActive(true);
        puzzles[puzzleIndex].Init();
    }

    public void taskSuccess()
    {
        puzzlesGameObject[puzzleIndex].SetActive(false);
        puzzleSucceed.Invoke();
        puzzleIndex = (puzzleIndex+1) % puzzlesGameObject.Count;
        glowingZone.SetActive(false);

        if(isFirst)
        {
            isFirst = false;
            ShootingUI.SetActive(false);
        }
    }       
    public void stopEveryThing()
    {

    }
    
}
