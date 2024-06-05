using Gamekit3D;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneTransition : MonoBehaviour
{
    public string nextSceneName;
    public ScreenFader.FadeType fadeType = ScreenFader.FadeType.Black;

    public void NextSceneStart()
    {
        StartCoroutine(ScreenFader.FadeSceneOut(fadeType));
        StopAllCoroutines();
        StartCoroutine(Process());
    }

    private IEnumerator Process()
    {
        while (ScreenFader.IsFading)
        {
            yield return null;
        }
        SceneManager.LoadScene(nextSceneName);
        yield break;
    }
}
