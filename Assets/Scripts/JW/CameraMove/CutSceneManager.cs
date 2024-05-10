using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class CutSceneManager : MonoBehaviour
{
    [System.Serializable]
    public struct CutAway
    {
        public GameObject firstCamera;
        public float waitSeconds;
        public GameObject secondCamera;
    }

    public string vrName = "";
    public GameObject mainCamera;
    public GameObject leftHand;
    public GameObject rightHand;
    public List<CutAway> cutAways;
    private int index = 0;

    private void Awake()
    {
        gameObject.SetActive(false);
    }

    private void OnEnable()
    {
        FirstScene();
    }
    public void FirstScene()
    {
        StartCoroutine(FirstProcess());
    }

    public void NextScene()
    {
        if(index >= cutAways.Count)
        {
            Debug.Log("in CutAwayManager : index out of range");
            return;
        }
        Debug.Log(string.Format("Scene {0} start!", index + 1));
        StopAllCoroutines();
        StartCoroutine(Process(index));
        index += 1;
    }

    private IEnumerator FirstProcess()
    {
        var wfs = new WaitForSeconds(0.2f);
        yield return wfs;
        GameObject vr = GameObject.Find(vrName);
        vr.SetActive(false);
        mainCamera.SetActive(true);
        leftHand.SetActive(true);
        rightHand.SetActive(true);
        NextScene();
        yield break;
    }

    private IEnumerator Process(int index)
    {
        var wfs = new WaitForSeconds(cutAways[index].waitSeconds);
        yield return wfs;
        cutAways[index].firstCamera.SetActive(false);
        cutAways[index].secondCamera.SetActive(true);
        NextScene();
        yield break;
    }
}
