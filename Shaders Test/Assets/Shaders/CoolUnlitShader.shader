Shader "Custom/CoolUnlitShader"
{
	Properties
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
	_Color("Tint", Color) = (1,1,1,1)

		_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255

		_ColorMask("Color Mask", Float) = 15

		_NoiseTex("Noise Texture", 2D) = "white" {}

		_DistortionDamper("Distortion Damper", float) = 30
		_DistortionSpreader("Distortion Spreader", float) = 30


		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
	}

		SubShader
	{
		Tags
	{
		"Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
		"PreviewType" = "Plane"
		"CanUseSpriteAtlas" = "True"
	}

		Stencil
	{
		Ref[_Stencil]
		Comp[_StencilComp]
		Pass[_StencilOp]
		ReadMask[_StencilReadMask]
		WriteMask[_StencilWriteMask]
	}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest[unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask[_ColorMask]

		Pass
	{
		Name "Default"
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0

#include "UnityCG.cginc"
#include "UnityUI.cginc"

#pragma multi_compile __ UNITY_UI_ALPHACLIP

		struct appdata_t
	{
		float4 vertex   : POSITION;
		float4 color    : COLOR;
		float2 texcoord : TEXCOORD0;
	};

	struct v2f
	{
		float4 vertex   : SV_POSITION;
		fixed4 color : COLOR;
		half2 texcoord  : TEXCOORD0;
		float4 worldPosition : TEXCOORD1;
	};

	fixed4 _Color;
	fixed4 _TextureSampleAdd;
	float4 _ClipRect;

	v2f vert(appdata_t IN)
	{
		v2f OUT;
		OUT.worldPosition = IN.vertex;
		OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

		OUT.texcoord = IN.texcoord;

#ifdef UNITY_HALF_TEXEL_OFFSET
		OUT.vertex.xy += (_ScreenParams.zw - 1.0) * float2(-1,1) * OUT.vertex.w;
#endif

		OUT.color = IN.color * _Color;
		return OUT;
	}

	sampler2D _MainTex;
	sampler2D _NoiseTex;

	float _DistortionDamper;

	float _DistortionSpreader;

	fixed4 frag(v2f IN) : SV_Target
	{
		// IN.texcoord
		float2 offset = float2(
			tex2D(_NoiseTex, float2(IN.worldPosition.y / _DistortionSpreader , _Time[1] / 50)).r,
			tex2D(_NoiseTex, float2(_Time[1] / 50,IN.worldPosition.x / _DistortionSpreader )).r
			);

	offset -= 0.5;

		half4 color = (tex2D(_MainTex, IN.texcoord + offset/ _DistortionDamper) + _TextureSampleAdd) * IN.color;

		//color.r = 1;


		color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);

#ifdef UNITY_UI_ALPHACLIP
		clip(color.a - 0.001);
#endif

		return color; // from 0 to 1.
	}
		ENDCG
	}
	}
}

//Shader "Unlit/CoolUnlitShader"
//{
//	Properties
//	{
//		_MainTex ("Texture", 2D) = "white" {}
//	}
//	SubShader
//	{
//		Tags { "RenderType"="Opaque" }
//		LOD 100
//
//		Pass
//		{
//			CGPROGRAM
//			#pragma vertex vert
//			#pragma fragment frag
//			// make fog work
//			#pragma multi_compile_fog
//			
//			#include "UnityCG.cginc"
//
//			struct appdata
//			{
//				float4 vertex : POSITION;
//				float2 uv : TEXCOORD0;
//			};
//
//			struct v2f
//			{
//				float2 uv : TEXCOORD0;
//				UNITY_FOG_COORDS(1)
//				float4 vertex : SV_POSITION;
//			};
//
//			sampler2D _MainTex;
//			float4 _MainTex_ST;
//			
//			v2f vert (appdata v)
//			{
//				v2f o;
//				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
//				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
//				UNITY_TRANSFER_FOG(o,o.vertex);
//				return o;
//			}
//			
//			fixed4 frag (v2f i) : SV_Target
//			{
//				// sample the texture
//				fixed4 col = tex2D(_MainTex, i.uv);
//				// apply fog
//				UNITY_APPLY_FOG(i.fogCoord, col);
//				return col;
//			}
//			ENDCG
//		}
//	}
//}

//Shader "Custom/CoolUnlitShader"
//{
//	Properties
//	{
//		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
//	_Color("Tint", Color) = (1,1,1,1)
//
//		_StencilComp("Stencil Comparison", Float) = 8
//		_Stencil("Stencil ID", Float) = 0
//		_StencilOp("Stencil Operation", Float) = 0
//		_StencilWriteMask("Stencil Write Mask", Float) = 255
//		_StencilReadMask("Stencil Read Mask", Float) = 255
//
//		_ColorMask("Color Mask", Float) = 15
//
//		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
//	}
//
//		SubShader
//	{
//		Tags
//	{
//		"Queue" = "Transparent"
//		"IgnoreProjector" = "True"
//		"RenderType" = "Transparent"
//		"PreviewType" = "Plane"
//		"CanUseSpriteAtlas" = "True"
//	}
//
//		Stencil
//	{
//		Ref[_Stencil]
//		Comp[_StencilComp]
//		Pass[_StencilOp]
//		ReadMask[_StencilReadMask]
//		WriteMask[_StencilWriteMask]
//	}
//
//		Cull Off
//		Lighting Off
//		ZWrite Off
//		ZTest[unity_GUIZTestMode]
//		Blend SrcAlpha OneMinusSrcAlpha
//		ColorMask[_ColorMask]
//
//		Pass
//	{
//		Name "Default"
//		CGPROGRAM
//#pragma vertex vert
//#pragma fragment frag
//#pragma target 2.0
//
//#include "UnityCG.cginc"
//#include "UnityUI.cginc"
//
//#pragma multi_compile __ UNITY_UI_ALPHACLIP
//
//		struct appdata_t
//	{
//		float4 vertex   : POSITION;
//		float4 color    : COLOR;
//		float2 texcoord : TEXCOORD0;
//		UNITY_VERTEX_INPUT_INSTANCE_ID
//	};
//
//	struct v2f
//	{
//		float4 vertex   : SV_POSITION;
//		fixed4 color : COLOR;
//		float2 texcoord  : TEXCOORD0;
//		float4 worldPosition : TEXCOORD1;
//		UNITY_VERTEX_OUTPUT_STEREO
//	};
//
//	fixed4 _Color;
//	fixed4 _TextureSampleAdd;
//	float4 _ClipRect;
//
//	v2f vert(appdata_t IN)
//	{
//		v2f OUT;
//		UNITY_SETUP_INSTANCE_ID(IN);
//		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
//		OUT.worldPosition = IN.vertex;
//		OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);
//
//		OUT.texcoord = IN.texcoord;
//
//		OUT.color = IN.color * _Color;
//		return OUT;
//	}
//
//	sampler2D _MainTex;
//
//	fixed4 frag(v2f IN) : SV_Target
//	{
//		half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;
//
//		color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
//
//#ifdef UNITY_UI_ALPHACLIP
//		clip(color.a - 0.001);
//#endif
//
//		return color;
//	}
//		ENDCG
//	}
//	}
//}
