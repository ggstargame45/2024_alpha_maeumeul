using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class BookShelfCleanCheck : MonoBehaviour
{
    private int cleanedBookCount = 0;
    public int cleanGoal = 3;
    public UnityEvent endEvent;

    public void Cleaned()
    {
        cleanedBookCount += 1;
        Debug.Log(cleanedBookCount);
        if(cleanedBookCount >= cleanGoal)
        {
            End();
        }
    }

    public void Cancel()
    {
        cleanedBookCount -= 1;
        Debug.Log(cleanedBookCount);
    }

    private void End()
    {
        endEvent?.Invoke();
    }
}
