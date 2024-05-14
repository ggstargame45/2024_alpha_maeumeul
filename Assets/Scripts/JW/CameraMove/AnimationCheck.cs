using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class AnimationCheck : MonoBehaviour
{
    Animator anim;
    public UnityEvent animationEndEvent;

    void Awake()
    {
        anim = GetComponent<Animator>();
    }

    void Update()
    {
        // 현재 애니메이션이 체크하고자 하는 애니메이션인지 확인
        if (anim.GetCurrentAnimatorStateInfo(0).IsName("Take 001") == true)
        {
            // 원하는 애니메이션이라면 플레이 중인지 체크
            float animTime = anim.GetCurrentAnimatorStateInfo(0).normalizedTime;
            if (animTime == 0)
            {
                // 플레이 중이 아님
            }
            if (animTime > 0 && animTime < 1.0f)
            {
                // 애니메이션 플레이 중
            }
            else if (animTime >= 1.0f)
            {
                animationEndEvent?.Invoke();
            }
        }
    }
}
