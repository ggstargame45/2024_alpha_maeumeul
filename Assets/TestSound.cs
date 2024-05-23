using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestSound : MonoBehaviour
{
    public AudioSource music;


    private void Start()
    {
        music.Play();
    }
}
