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

    public int puzzleIndex;
    public bool isAvailable = false;

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
        if(isAvailable)
        {
            return;
        }
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
    }       
    
}
