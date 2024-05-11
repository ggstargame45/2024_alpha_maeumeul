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
        // ���� �ִϸ��̼��� üũ�ϰ��� �ϴ� �ִϸ��̼����� Ȯ��
        if (anim.GetCurrentAnimatorStateInfo(0).IsName("Take 001") == true)
        {
            // ���ϴ� �ִϸ��̼��̶�� �÷��� ������ üũ
            float animTime = anim.GetCurrentAnimatorStateInfo(0).normalizedTime;
            if (animTime == 0)
            {
                // �÷��� ���� �ƴ�
            }
            if (animTime > 0 && animTime < 1.0f)
            {
                // �ִϸ��̼� �÷��� ��
            }
            else if (animTime >= 1.0f)
            {
                animationEndEvent?.Invoke();
            }
        }
    }
}
