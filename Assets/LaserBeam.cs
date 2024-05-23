using UnityEngine;
using System.Collections;

public class LaserBeam : MonoBehaviour
{
    public Transform laserOrigin;
    public float laserDuration = 1.0f; // Duration the laser will be visible
    public float laserLength = 100.0f;
    public LineRenderer lineRenderer;


    void Start()
    {
        lineRenderer.enabled = false;
    }

    //void Update()
    //{
    //    ShootLaser();
    //}

    public void FireLaser()
    {
        StartCoroutine(ShowLaser());
    }

    private IEnumerator ShowLaser()
    {
        lineRenderer.enabled = true;

        // Perform a raycast from the laser origin
        RaycastHit hit;
        Vector3 endPosition = laserOrigin.position + laserOrigin.forward * laserLength;

        if (Physics.Raycast(laserOrigin.position, laserOrigin.forward, out hit, laserLength))
        {
            endPosition = hit.point;
        }

        // Set the positions of the line renderer
        lineRenderer.SetPosition(0, laserOrigin.position);
        lineRenderer.SetPosition(1, endPosition);

        // Wait for the specified duration
        yield return new WaitForSeconds(laserDuration);

        // Disable the line renderer
        lineRenderer.enabled = false;
    }
}