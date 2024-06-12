//using UnityEngine;
//using UnityEditor;
//using UnityEngine.Events;

//[CustomEditor(typeof(MyComponent))]
//public class MyComponentEditor : Editor
//{

//    void drawButton()
//    {
        
//    }
//    public override void OnInspectorGUI()
//    {
//        DrawDefaultInspector();

//        // Get a reference to the target script
//        MyComponent myComponent = (MyComponent)target;

//        for (int i = 0; i < myComponent.eventOne.Length; i++)
//        {
//            if (GUILayout.Button("Execute Event " + i))
//            {
//                myComponent.eventOne[i].Invoke();
//            }
//        }




//        //// Add a button for each event
//        //if (GUILayout.Button("Execute Event One"))
//        //{
//        //    myComponent;
//        //}

//        //if (GUILayout.Button("Execute Event Two"))
//        //{
//        //    myComponent.InvokeEventTwo();
//        //}

//        //if (GUILayout.Button("Execute Event Three"))
//        //{
//        //    myComponent.InvokeEventThree();
//        //}
//    }
//}
