using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestIndivShootPuzzle : MonoBehaviour
{
    public UnityEvent puzzleSuccessEvent;

    public List<TestPictureTile> testPictureTiles;

    public List<int> initialAnswerTileIndex;

    public List<bool> currentTrue;


    public void setAnswerTileIndex(List<int> answerTileIndex)
    {
        initialAnswerTileIndex = answerTileIndex;
    }
    public void Success()
    {
        Debug.Log("Success");
        puzzleSuccessEvent.Invoke();
    }

    public void Init()
    {
        currentTrue = new List<bool>();

        for (int i = 0; i < 16; i++)
        {
            testPictureTiles.Add(transform.GetChild(0).GetChild(i).GetComponent<TestPictureTile>());
            currentTrue.Add(true);
            testPictureTiles[i].SetAnswer(false);
            testPictureTiles[i].index = i;
        }

        foreach (int index in initialAnswerTileIndex)
        {
            testPictureTiles[index].SetAnswer(true);
            currentTrue[index] = false;
        }

    }

    public void flipEvent(int flippedIndex, bool needFlip)
    {
        currentTrue[flippedIndex] = !needFlip;
        Debug.Log("Flip Event : " + flippedIndex.ToString() + " : " + needFlip.ToString());
        for (int i = 0; i < 16; i++)
        {
            Debug.Log("index : " + i.ToString() + " :" + currentTrue[i]);
        }

        if (!needFlip)
        {
            checkSuccess();
        }
    }

    public void checkSuccess()
    {

        Debug.Log("Check Success");
        

        bool success = true;
        foreach (bool b in currentTrue)
        {
            if (!b)
            {
                success = false;
                break;
            }
        }


        if (success)
        {
            Success();
        }

    }
}
