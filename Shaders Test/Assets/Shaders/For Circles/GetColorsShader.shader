Shader "Custom/GetColorsShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}

		_D("D", int) = 100
		_X("X", int) = 100
		_Y("Y", int) = 100

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
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			float _Radius;

			fixed4 frag(v2f IN) : SV_Target
			{
				float d = _Radius * 2;
				int col = IN.vertex.x;// / d;
				int row = IN.vertex.y;// / d;

				/*for (int i = 0; i < d; i++)
				{
					for (int j = 0; j < d; j++)
					{
							
					}
				}*/

				//fixed4 color = tex2D(_MainTex, IN.uv);

				if ((col + row) % 2 == 0)
				{
					return 1;
				}
				else
				{
					return 0;
				}

				//return color;
			}
			ENDCG
		}
	}
}
