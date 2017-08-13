using UnityEngine;
using System.Collections;

public class LowResolutionCameraScript : MonoBehaviour {
    [Range(50,1000)]
    public int horizontalResolution = 160;

    [Range(50, 1000)]
    public int verticalResolution = 200;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture scaled = RenderTexture.GetTemporary(horizontalResolution, verticalResolution);
        Graphics.Blit(source, scaled);
        Graphics.Blit(scaled, destination);

        RenderTexture.ReleaseTemporary(scaled);
    }
}
