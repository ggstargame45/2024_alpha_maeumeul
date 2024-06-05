using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Autohand.Demo
{
    public class ToggleHandProjection : MonoBehaviour
    {
        private void Start()
        {
            EnableHighlightProjection();
        }


        public void EnableHighlightProjection()
        {
            var projections = AutoHandExtensions.CanFindObjectsOfType<HandProjector>(true);

            foreach (var projection in projections)
            {
                projection.gameObject.SetActive(true);
                if (!projection.useGrabTransition)
                    projection.enabled = true;
            }
        }
    }
}