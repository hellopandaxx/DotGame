Shader "Custom/GetColorsShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}

		_D("D", float) = 100
		/*_X("X", int) = 100
		_Y("Y", int) = 100*/

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
				fixed4 color : COLOR;

			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				o.color = v.color;
				return o;
			}

			sampler2D _MainTex;
			float _D;

			fixed4 frag(v2f IN) : SV_Target
			{
				// float d = _Radius * 2;
				int col = IN.vertex.x; /// _D;// / d;
			int row = IN.vertex.y;// / _D;// / d;

				//if ((col + row) % 2 == 0) // TODO: use UINT
				//{
				//	return 0;
				//}
				//else
				//{
				//	return 0.5;
				//}
				fixed4 color = 1;
				color.b = color.g = 0;
				color.r = 1 - IN.vertex.y;
				return  tex2D(_MainTex, IN.uv);

				//color = 1;
				//color.r = IN.uv.x;
				//color.g = IN.uv.y;

				///*if(color.r + color.g <= 0.05)
				//{
				//	color.b = 0;
				//}*/

				///*if (col == 1 || row == 28)
				//{
				//	color.b = 0;
				//}*/

				//if ((col + row) % 2 == 0)
				//{
				//	color.b = 0;
				//}

				///*if (row == 1)
				//{
				//	color.rgb = 0;
				//}*/

				//return color;
			}
			ENDCG
		}
	}
}
