using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaskScript : MonoBehaviour
{
    public GameObject[] maskedGO;

    // Start is called before the first frame update
    void Start()
    {
        for(int i = 0; i < maskedGO.Length; i++)
        {
            maskedGO[i].GetComponent<MeshRenderer>().material.renderQueue = 3002;
        }
    }

}
