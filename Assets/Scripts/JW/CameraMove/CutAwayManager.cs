using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class CutAwayManager : MonoBehaviour
{
    [System.Serializable]
    public struct Action
    {
        public float waitSeconds;
        public UnityEvent CutAwayEvent;
    }

    public List<Action> actions;
    private int index = 0;

    private void OnEnable()
    {
        Next();
        index += 1;
    }

    public void Next()
    {
        StopAllCoroutines();
        StartCoroutine(Process(index));
        index += 1;
    }

    private IEnumerator Process(int index)
    {
        var wait = new WaitForSeconds(actions[index].waitSeconds);
        yield return wait;
        actions[index].CutAwayEvent?.Invoke();
        yield break;
    }
}
