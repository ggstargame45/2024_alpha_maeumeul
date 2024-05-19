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
        goMaterial.shader = goShader;
        renderer.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
        renderer.material.color = new Color(0f, 0f, 0f, 0f);
    }

    void Start()
    {
        objects = Resources.LoadAll(string.Format("Sequence/{0}", fileName), typeof(Texture));
        textures = new Texture[objects.Length];
        for(int i = 0; i < objects.Length; i++)
        {
            textures[i] = (Texture)objects[i];
            textures[i].filterMode = FilterMode.Point;
            textures[i].anisoLevel = 16;
            textures[i].mipMapBias = -0.5f;
        }
        //Call(); // TESTCODE
    }

    public void Call()
    {
        StopAllCoroutines();
        StartCoroutine(Process());
    }

    private IEnumerator Process()
    {
        index = 0;
        gameObject.GetComponent<Renderer>().material.color = new Color(0f, 0f, 0f, 1f);
        var wfs = new WaitForSeconds(1f / 60f);
        while(index < textures.Length)
        {
            goMaterial.mainTexture = textures[index];
            index++;
            yield return wfs;
        }
        yield break;
    }
}
