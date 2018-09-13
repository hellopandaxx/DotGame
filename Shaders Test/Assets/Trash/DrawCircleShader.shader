// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Circle1Shader"
{
	Properties{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,0,0,0)
	}
		SubShader{
		Pass{
		CGPROGRAM

#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

		fixed4 _Color; // low precision type is usually enough for colors

	struct fragmentInput {
		float4 pos : SV_POSITION;
		float2 uv : TEXTCOORD0;
	};

	fragmentInput vert(appdata_base v)
	{
		fragmentInput o;

		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy;// -fixed2(0.5, 0.5);

		return o;
	}

	sampler2D _MainTex;

	// Drawing a cercle with centr centerX:centerY (based on screen coordinates),
	// with radius = distance.
	fixed4 frag(fragmentInput i) : SV_Target
	{

		float centerX = _ScreenParams.x/2; //300.0f;
		float centerY = _ScreenParams.y/2; //200.0f;

		float distance = sqrt(pow(centerX - i.pos.x, 2) + pow(centerY-i.pos.y,2));

		if (distance > 100.0f)
		{
			// Transparent (Main image).
			return tex2D(_MainTex, i.uv);

			// Black.
			//return fixed4(0,0,0,1);
		}
		else {
			// Dot Color.
			return fixed4(0.5f,0.5f,0.5,0);
		}
	}


		//float distance = sqrt(pow(i.uv.x, 2) + pow(i.uv.y,2));
		//float distancez = sqrt(distance * distance + i.l.z * i.l.z);
		ENDCG
	}
	}

	/*Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				col = 1 - col;
				return col;
			}
			ENDCG
		}
	}*/
}
