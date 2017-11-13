Shader "Custom/Circle1AA"
{
	Properties{
		// Original screen image (Currently not used)
		_MainTex("Texture", 2D) = "white" {}

		// Two-dimensional array of collors for Dots.
		_ColorMap("Texture", 2D) = "white" {}

		// The diameter of one Dot.
		_D("D", float) = 40
		_DeltaD("DeltaD", float) = 0

		// Antiallisassing drop-off.
		_Dropoff("Dropoff", Range(0.01, 4)) = 0.1

		// The dimensions of the screen in Dots.
		_DotsWidth("DotsWidth", int) = 1
		_DotsHeight("DotsHeight", int) = 1


		//[HideInInspector]
		//_BackColor("Background Color", Color) = (0,0,0,1)
		//_Radius("Radius", float) = 20
	}
		SubShader {
		Cull Off ZWrite Off ZTest Always

// ==================== PAS 1 ==================================

		Pass // Makes Black Background
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
		
		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex, i.uv);
			col.rgb = 0;

			return col;
		}

		ENDCG
	}

// ==================== PAS 2 ==================================

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha // Alpha blending
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct fragmentInput {
				float4 pos : SV_POSITION; // - screen position
				float2 uv : TEXTCOORD0;
			};

			fragmentInput vert(appdata v)
			{
				fragmentInput o;

				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv; //v.texcoord.xy;// -fixed2(0.5, 0.5);

				return o;
			}

			// r = radius
			// d = distance
			// p = % thickness used for Dropoff
			float antialias(float r, float d, float p)
			{
				if (d < r)
					return 1.0;
				else
					return (-pow(d - r, 2) / pow(p, 2)) + 1.0;
			}

			sampler2D _ColorMap;

			// Testing.
			sampler2D _MainTex;
			float4 _MainTex_TexelSize;

			float _D;
			float _DeltaD;
			float _Dropoff;
			float _DotsWidth;
			float _DotsHeight;

			fixed4 frag(fragmentInput i) : SV_Target
			{
				float d = _D;
				float radius = _D / 2;
				float internalRadius = (_D - _DeltaD) / 2;

				// i.pos.x - coordinates in pixels??
				int col = i.pos.x / d;
				int row = i.pos.y / d;

				float centerX = col * d + radius;
				float centerY = row * d + radius;

				float distance = sqrt(pow(centerX - i.pos.x, 2) + pow(centerY - i.pos.y, 2));
				fixed4 result = fixed4(1, 1, 1, 1*antialias(internalRadius, distance, _Dropoff));
		
				// Half screen testing.
				/*if (i.pos.x > _MainTex_TexelSize.z / 2)
				{
					return tex2D(_MainTex, i.uv);
				}*/

				// I use (row + 1) here in order to prevent the first and second lines from displaying the same colors.
				float2 position = float2(col / _DotsWidth, 1.0 - (row + 1) / _DotsHeight);
				result.rgb = tex2D(_ColorMap, position).rgb;

				if (row == 0 || row == _DotsHeight - 1)
				{
					result.rgb = 0;
				}

				return result;
			}

			ENDCG
		}
	}
}
		//float radius = _Radius;
		/*
		int colsCount = _ScreenParams.x / d;
		int rowsCount = _ScreenParams.y / d;
		*/
		//result.rgb = tex2Dlod(_ColorMap, float4(col, row, 0, 0))*255;

//int myDotH = _DotsHeight;
//int myDotW = _DotsWidth;
//if(col == myDotW && row == myDotH)
//{
// result.r = 1;
// result.g = 0;
// result.b = 0;
//}
		//result.rgb = tex2D(_ColorMap, /*fixed2(colsCount/col, rowsCount/row)*/ float2(i.uv.x, 1-i.uv.y)).rgb;

	// The code for render the circle in the center of screen with spetified radius.
	/*fixed4 frag(fragmentInput i) : SV_Target
	{
		float centerX = _ScreenParams.x / 2;
		float centerY = _ScreenParams.y / 2;

		float distance = sqrt(pow(centerX - i.pos.x, 2) + pow(centerY - i.pos.y, 2));
		fixed4 result = fixed4(_Color.r, _Color.g, _Color.b, _Color.a*antialias(_Radius, distance, _Dropoff));
		
		return result;
	}*/



		// Basic function:
		// r = radius
		// d = distance
		// t = thickness
		// p = % thickness used for Dropoff
		/*float antialias(float r, float d, float t, float p) {
			if (d < (r - 0.5*t))
				return -pow(d - r + 0.5*t, 2) / pow(p*t, 2) + 1.0;
			else if (d >(r + 0.5*t))
				return -pow(d - r - 0.5*t, 2) / pow(p*t, 2) + 1.0;
			else
				return 1.0;
		}*/


