using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeMaterial : MonoBehaviour
{
    private MeshRenderer meshRenderer;
    public Material changeMaterial;

    private void Awake()
    {
        meshRenderer = GetComponent<MeshRenderer>();
    }

    public void Call()
    {
        if (meshRenderer == null || changeMaterial == null)
        {
            return;
        }
        meshRenderer.material = changeMaterial;
    }
}
