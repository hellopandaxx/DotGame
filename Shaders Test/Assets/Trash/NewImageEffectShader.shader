// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/NewImageEffectShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;

			fixed4 frag(v2f IN) : SV_Target
			{
				
				// give me a color in _MainTex image at IN.uv coordinates
				fixed4 col = tex2D(_MainTex, IN.uv); // red, gree, blue, aplha

			/*float a = 2.18;
			float b = 3.17;
			float c = a*b;
			float d = pow(a, c);*/
			
			fixed ave = (col.r + col.g + col.b)/3;
			
			//col.r = col.g = col.b = ave;
			col = ave;
			//col.b = 0.5;
			// just invert the colors
			//col = 1 - col;
			//col++;
			//col.r
			
			return col;

			}
			ENDCG
		}
	}
}
