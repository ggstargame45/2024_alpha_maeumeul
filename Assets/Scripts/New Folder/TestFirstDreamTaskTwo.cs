using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestFirstDreamTaskTwo : MonoBehaviour
{
    public UnityEvent incrementScore;
    public TestFirstDreamTaskOne testFirstDreamTaskOne;


    // Start is called before the first frame update
    void Start()
    {
        
    }

    void StartTask()
    {

    }

    public void TaskSuccess()
    {
        incrementScore.Invoke();
        testFirstDreamTaskOne.gameObject.SetActive(true);

    }

}
