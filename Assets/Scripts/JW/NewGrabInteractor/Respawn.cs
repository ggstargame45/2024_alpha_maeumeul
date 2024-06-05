using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class Respawn : MonoBehaviour
{
    private void Update()
    {
        if(gameObject.transform.position.y < 0)
        {
            gameObject.transform.position = new Vector3(0.15f, 1.1f, 0.5f);
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if(collision.gameObject.tag == "Floor")
        {
            gameObject.transform.position = new Vector3(0.15f, 1.1f, 0.5f);
        }
    }
}
