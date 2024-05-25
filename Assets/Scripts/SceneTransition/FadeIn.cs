using Gamekit3D;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FadeIn : MonoBehaviour
{
    private void Start()
    {
        StartCoroutine(ScreenFader.FadeSceneIn());
    }
}
