using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Light : MonoBehaviour
{
    public enum LightType { Directional, Point };
    public LightType type;
    public Material[] mats;
    public Color color;
    //public float range = 5.0f;
    
    //Vector3 direction;
    //Color color;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //if(type == LightType.Directional)
        //{
        //    mat.SetVector("_directionalLightDir", -direction);
        //    mat.SetColor("_directionalLightColor", color);
        //}
        if(type == LightType.Point)
        {
            for (int i = 0; i < mats.Length; i++)
            {
                mats[i].SetVector("_directionalLightPos", transform.position);
                mats[i].SetColor("_directionalLightColor", color);
            }
        }

    }
}
