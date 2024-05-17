using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SequenceImagePlayer : MonoBehaviour
{
    public string fileName;
    private Object[] objects;
    private Texture[] textures;
    private Material goMaterial;
    private int index = 0;

    private void Awake()
    {
        var renderer = gameObject.GetComponent<Renderer>();
        var goShader = renderer.material.shader;
        goMaterial = renderer.material;
        goMaterial.shader = goShader; //Shader.Find("Universal Render Pipeline/Complex Lit");
    }

    void Start()
    {
        objects = Resources.LoadAll(string.Format("Sequence/{0}", fileName), typeof(Texture));
        textures = new Texture[objects.Length];
        for(int i = 0; i < objects.Length; i++)
        {
            textures[i] = (Texture)objects[i];
        }
        Call(); // TESTCODE
    }

    private void Call()
    {
        StopAllCoroutines();
        StartCoroutine(Process());
    }

    private IEnumerator Process()
    {
        index = 0;
        while(index < textures.Length)
        {
            goMaterial.mainTexture = textures[index];
            index++;
            yield return null;
        }
        yield break;
    }
}
