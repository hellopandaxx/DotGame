using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class PostEffect : MonoBehaviour
{
    /*
    public RenderTexture renderTexture;

    void Start()
    {
        int realRatio = Mathf.RoundToInt(Screen.width / Screen.height);
        renderTexture.width = NearestSuperiorPowerOf2(Mathf.RoundToInt(renderTexture.width * realRatio));
        Debug.Log("(Pixelation)(Start)renderTexture.width: " + renderTexture.width);
    }

    void OnGUI()
    {
        GUI.depth = 20;
        GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), renderTexture);
    }

    int NearestSuperiorPowerOf2(int n)
    {
        return (int)Mathf.Pow(2, Mathf.Ceil(Mathf.Log(n) / Mathf.Log(2)));
    }*/

    
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public Material getColorsMaterial;
    public Material dotMaterial;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        //var c = new Color[32];
        //c[0] = Color.green;
        //dotMaterial.SetColorArray("_colorArray", c);

        // ===========================================================

        var screenWidth = Screen.width;
        var screenHeight = Screen.height;

        var radius =  dotMaterial.GetInt("_Radius");

        var d = radius * 2;

        var newx = screenWidth / d;
        var newy = screenHeight / d;


        var tex = RenderTexture.GetTemporary(newx, newy);
        tex.antiAliasing = 1;
        tex.depth = 24;
        //tex.enableRandomWrite = true;
        Texture2D tex2d = new Texture2D(newx, newy, TextureFormat.RGBA32, false);
        
        //mat1.SetColorArray

        Graphics.Blit(src, tex, getColorsMaterial);

         dotMaterial.SetTexture("_ColorMap", tex);

        Graphics.Blit(src, dest, dotMaterial);
        RenderTexture.ReleaseTemporary(tex);

        // (this.GetComponent("Material") as Material).SetColorArray; !!!

        //Graphics.Blit(src, stage1, mat1);
        //Graphics.Blit(stage1, dest, mat2);
    }
}
