Shader "Custom/Circle1AA"
{
	Properties{
		_MainTex("Texture", 2D) = "white" {}
		_ColorMap("Texture", 2D) = "white" {}

		//[HideInInspector]
		_Color("Color", Color) = (1,0,0,0)
		_BackColor("Background Color", Color) = (0,0,0,1)

		_D("D", int) = 40
			_Radius("Radius", int) = 20
		_Dropoff("Dropoff", Range(0.01, 4)) = 0.1

	}
		SubShader {
		Cull Off ZWrite Off ZTest Always

		Pass // Make Black Background
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

		// uniform fixed4 _Color1;
		
		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uv = v.uv;
			return o;
		}

		sampler2D _MainTex;
		uniform fixed4 _colorArray[32];
		
		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex, i.uv);
			col.rgb = 0;

			return col;
		}

		ENDCG
	}


// ==================== PAS 2 ==================================


		Pass{
		Blend SrcAlpha OneMinusSrcAlpha // Alpha blending
		CGPROGRAM

#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"


		fixed4 _Color; // low precision type is usually enough for colors
		fixed4 _BackColor;
		//fixed4 _Color1;
	float _Thickness;
	float _D;
	float _Radius;
	float _Dropoff;

	//sampler2D _Colors;
	//uniform fixed4 _colorArray[32];
	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct fragmentInput {
		float4 pos : SV_POSITION;
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
	sampler2D _MainTex;

	fixed4 frag(fragmentInput i) : SV_Target
	{
		float d = _D;
		//float radius = _Radius;
		float radius = _D / 2;

		int col = i.pos.x / d;
		int row = i.pos.y / d;
		/*
		int colsCount = _ScreenParams.x / d;
		int rowsCount = _ScreenParams.y / d;
		*/

		float centerX = col * d + radius; //_ScreenParams.x / 2;
		float centerY = row * d + radius; //_ScreenParams.y / 2;

		float distance = sqrt(pow(centerX - i.pos.x, 2) + pow(centerY - i.pos.y, 2));
		fixed4 result = fixed4(_Color.r, _Color.g, _Color.b, _Color.a*antialias(radius, distance, _Dropoff));

		//result.rgb = tex2Dlod(_ColorMap, float4(col, row, 0, 0))*255;

		result.rgb = tex2D(_ColorMap, /*fixed2(colsCount/col, rowsCount/row)*/ float2(i.uv.x, 1-i.uv.y)).rgb;

		return result;
	}

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



			ENDCG
		}
	}
}
