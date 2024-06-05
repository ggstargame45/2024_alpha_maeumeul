using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class TestFirstDreamTaskOne : MonoBehaviour
{
    public UnityEvent incrementScore;
    public TestFirstDreamTaskTwo testFirstDreamTaskTwo;


    // Start is called before the first frame update
    void Start()
    {
        
    }


    public void TaskSuccess()
    {
        incrementScore.Invoke();
        testFirstDreamTaskTwo.gameObject.SetActive(true);
    }

}
