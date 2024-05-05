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
        public GameObject secondCamera;
        public float waitSeconds;
    }

    public GameObject mainCamera;
    public List<CutAway> cutAways;
    private int index = 0;

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
        StopAllCoroutines();
        StartCoroutine(Process(cutAways[index].waitSeconds));
    }

    private IEnumerator FirstProcess()
    {
        var wfs = new WaitForSeconds(0.2f);
        yield return wfs;
        GameObject vr = GameObject.Find("XR Origin (XR Rig)(Clone)");
        Destroy(vr);
        mainCamera.SetActive(true);
        NextScene();
        yield break;
    }

    private IEnumerator Process(float waitSeconds)
    {
        var wfs = new WaitForSeconds(waitSeconds);
        yield return wfs;
        cutAways[index].firstCamera.SetActive(false);
        cutAways[index].secondCamera.SetActive(true);
        yield break;
    }
}
