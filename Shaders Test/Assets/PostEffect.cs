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

    /*
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        //  RenderTexture.active = src;
        //  Texture2D myTexture2D = new Texture2D(src.width, src.height);
        //  myTexture2D.ReadPixels(new Rect(0, 0, myTexture2D.width, myTexture2D.height), 0, 0);
        //  RenderTexture.active = null;

        //  myTexture2D.Apply();
        //  var pixels = myTexture2D.GetPixels();
           
    }
    */

    public Material getColorsMaterial;
    public Material dotMaterial;

    public const int screenHeigthInDots = 30;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        var screenHeight = Screen.height; // TODO: Optimize
        float d = screenHeight / screenHeigthInDots;

        int screenWidthInDots = Screen.width / (int)d;

        var tex = RenderTexture.GetTemporary(screenWidthInDots, screenHeigthInDots);
        //tex.antiAliasing = 1;
        Graphics.Blit(src, tex); // Down scale (get colors emulation)

        dotMaterial.SetTexture("_ColorMap", tex);
        dotMaterial.SetFloat("_D", d);
        dotMaterial.SetFloat("_Radius", d / 2);
        dotMaterial.SetInt("_DotsWidth", screenWidthInDots);
        dotMaterial.SetInt("_DotsHeight", screenHeigthInDots);
        Graphics.Blit(src, dest, dotMaterial);
        //Graphics.Blit(tex, dest);
        RenderTexture.ReleaseTemporary(tex);
    }

    void OnRenderImageOLD(RenderTexture src, RenderTexture dest)
    {
        var screenWidth = Screen.width;
        var screenHeight = Screen.height;

        var radius = dotMaterial.GetInt("_Radius");

        var d = radius * 2;

        var newx = screenWidth / d + 1;
        var newy = screenHeight / d + 1;


        var tex = RenderTexture.GetTemporary(newx, newy);
        tex.antiAliasing = 1;
        // tex.depth = 24;
        //tex.enableRandomWrite = true;
        // Texture2D tex2d = new Texture2D(newx, newy, TextureFormat.RGBA32, false);

        //mat1.SetColorArray

        Graphics.Blit(src, tex, getColorsMaterial);

        dotMaterial.SetTexture("_ColorMap", tex);

        // dotMaterial.SetInt ...

        Graphics.Blit(src, dest, dotMaterial);
        RenderTexture.ReleaseTemporary(tex);

        // (this.GetComponent("Material") as Material).SetColorArray; !!!

        //Graphics.Blit(src, stage1, mat1);
        //Graphics.Blit(stage1, dest, mat2);
    }
}
