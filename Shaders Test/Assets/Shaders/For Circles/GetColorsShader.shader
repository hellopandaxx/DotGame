// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GetColorsShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}

		_D("D", float) = 10

		_DotsHeight("DotsHeight", int) = 30

		_Phase("Phase", float) = 0

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
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.color = v.color;
				return o;
			}

			sampler2D _MainTex;
			float _D;
			int _DotsHeight;

			float _Phase;
			
			float2 _MainTex_TexelSize;

			fixed4 getColorFromCell(int col, int row)
			{
				float4 result = 0;

				float TX_x = _MainTex_TexelSize.x;
                
                // Is it that thing about texel size revert in D3D? -> Yes.
                // For D3D we use _MainTex_TexelSize.y with minus (negative).
                // For Mac we use _MainTex_TexelSize.y as is.
				//float TX_y = -_MainTex_TexelSize.y;  // For D3D.
                float TX_y = _MainTex_TexelSize.y;
				
				int pixCount = 0;
				for (int x = 0; x < _D; x += 2)
				{
					for (int y = 0; y < _D; y += 2)
					{
						//_Phase = 0;
						float2 position = float2((col*_D + x + (_Phase*_D))*TX_x, (row*_D + y)*TX_y);
						fixed4 pixColor = tex2D(_MainTex, position);

						result += pixColor;
						pixCount++;
					}
				}

				result /= (pixCount);

				return result;
			}

			fixed4 frag(v2f IN) : SV_Target
			{
				int col = IN.vertex.x;
				int row = _DotsHeight - IN.vertex.y;							

				return getColorFromCell(col, row);				
			}
							
			ENDCG
		}
	}
}
