using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HandTrader : MonoBehaviour
{
    [System.Serializable]
    public struct Hands
    {
        public GameObject prevHand;
        public GameObject nextHand;
    }

    public List<Hands> hands;
    private int index = 0;
    public void Trade()
    {
        hands[index].prevHand.SetActive(false);
        hands[index].nextHand.SetActive(true);
        index += 1;
    }
}
