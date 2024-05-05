using System.Collections;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class SocketRotation : MonoBehaviour
{
    private GameObject otherObject;
    public string socketInteractionTag = "default";
    public Transform socketTransform;


    private void OnTriggerEnter(Collider other)
    {
        otherObject = other.gameObject;
        var temp = otherObject.GetComponent<AutoHandSocketInteractable>();
        if (temp == null)
        {
            otherObject = null;
            return;
        }
        if (!(temp.canInteract && socketInteractionTag.Equals(temp.socketInteractionTag)))
        {
            otherObject = null;
            return;
        }
        On();
    }

    private void OnTriggerExit(Collider other)
    {
        otherObject = null;
        Off();
    }

    public void On()
    {
        StopAllCoroutines();
        if (gameObject.activeSelf)
        {
            StartCoroutine(Process());
        }
    }

    public void Off()
    {
        StopAllCoroutines();
    }

    private IEnumerator Process()
    {
        while (true)
        {
            if (otherObject == null || socketTransform == null)
            {
                yield break;
            }

            var angleY = Mathf.Abs(gameObject.transform.eulerAngles.y - otherObject.transform.eulerAngles.y);
            var angleX = Mathf.Abs(gameObject.transform.eulerAngles.x - otherObject.transform.eulerAngles.x);
            var angleZ = Mathf.Abs(gameObject.transform.eulerAngles.z - otherObject.transform.eulerAngles.z);

            float y = 0f;
            float x = 0f;
            float z = 0f;
            if (!(90f < angleY && angleY < 270f))
            {
                y = 180f;
            }
            if (!(90f < angleX && angleX < 270f))
            {
                x = 180f;
            }
            if (!(90f < angleZ && angleZ < 270f))
            {
                z = 180f;
            }
            socketTransform.rotation = Quaternion.Euler(x, y, z);
            Debug.Log(socketTransform.rotation.eulerAngles);
            yield return null;
        }
    }
}
