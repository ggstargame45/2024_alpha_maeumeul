Shader "Ciconia Studio/CS_Sparkle/Builtin/Sparkle"
{
	Properties
	{
		[Space(35)][Header(Main Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_GlobalXYTilingXYZWOffsetXY("Global --> XY(TilingXY) - ZW(OffsetXY)", Vector) = (1,1,0,0)
		_Color("Color", Color) = (1,1,1,0)
		[Toggle]_InvertABaseColor("Invert Alpha", Float) = 0
		_MainTex("Base Color", 2D) = "white" {}
		_Saturation("Saturation", Float) = 0
		_Brightness("Brightness", Range( 1 , 8)) = 1
		[Space(35)]_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Normal Intensity", Float) = 0.3
		[Space(35)]_MetallicGlossMapMAHS("Mask Map  -->M(R) - Ao(G) - Dm(B) - S(A)", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 2)) = 0
		_Glossiness("Smoothness", Range( 0 , 2)) = 0.5
		[Space(10)][KeywordEnum(MetallicAlpha,BaseColorAlpha)] _Source("Source", Float) = 0
		[Space(15)]_AoIntensity("Ao Intensity", Range( 0 , 2)) = 0
		[Space(35)]_ParallaxMap("Height Map", 2D) = "white" {}
		_Parallax("Height Scale", Range( -0.1 , 0.1)) = 0
		[HDR][Space(45)]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_EmissionMap("Emission Map", 2D) = "white" {}
		_EmissionIntensity("Intensity", Range( 0 , 2)) = 1
		[Space(35)][Header(Mask Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Toggle]_EnableDetailMask("Enable", Float) = 1
		[Space(15)][Toggle]_VisualizeMask("Visualize Mask", Float) = 1
		[Toggle]_SourceMask("Source - Use Detail Mask (B)", Float) = 0
		[Space(15)][Toggle]_InvertMask("Invert Mask", Float) = 0
		_DetailMask("Detail Mask", 2D) = "black" {}
		_IntensityMask("Intensity", Range( 0 , 1)) = 1
		[Space(15)]_ContrastDetailMap("Contrast", Float) = 0
		_SpreadDetailMap("Spread", Range( 0 , 1)) = 0.5
		[Space(35)][Header(Sparkle Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)][KeywordEnum(None,EmissiveSparkles,SmoothnessSparkles)] _SparkleSource("Source", Float) = 1
		[Space(15)][KeywordEnum(None,DotMask,SparkleMap)] _VisualizeSparkle("Visualize Maps", Float) = 0
		_DotMask("Dot Mask", 2D) = "white" {}
		_TilingDotMask("Tiling", Float) = 1
		_IntensityDotMask("Intensity", Range( 0 , 1)) = 1
		[Space(15)]_ContrastDotMask("Contrast", Float) = 0
		_SpreadDotMask("Spread", Range( 0 , 1)) = 0.5
		[Space(30)][KeywordEnum(ScreenPosition,VertexPosition)] _SpaceProjection("SpaceProjection", Float) = 0
		_SparkleMap("Sparkle Map", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		_TilingCrystals("Tiling", Float) = 1
		_CrystalsIntensity("Intensity", Range( 0 , 5)) = 1
		[Space(15)]_ContrastSparkles("Contrast", Float) = 0
		_AmountSparkle("Amount", Range( 0 , 1)) = 1
		[Space(15)]_Desaturatecrystals("Desaturate", Range( 0 , 1)) = 0
		_ShadowMask("Shadow Mask", Range( 0 , 1)) = 1
		[Toggle]_AoMask("Ao Mask", Float) = 0
		[Header(Custom Properties)]_TilingInstance("Tiling Instance", Float) = 1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _VISUALIZESPARKLE_NONE _VISUALIZESPARKLE_DOTMASK _VISUALIZESPARKLE_SPARKLEMAP
		#pragma shader_feature_local _SPARKLESOURCE_NONE _SPARKLESOURCE_EMISSIVESPARKLES _SPARKLESOURCE_SMOOTHNESSSPARKLES
		#pragma shader_feature_local _SPACEPROJECTION_SCREENPOSITION _SPACEPROJECTION_VERTEXPOSITION
		#pragma shader_feature_local _SOURCE_METALLICALPHA _SOURCE_BASECOLORALPHA
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 viewDir;
			half ASEVFace : VFACE;
			float4 screenPos;
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float _VisualizeMask;
		uniform float _Brightness;
		uniform float4 _Color;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _GlobalXYTilingXYZWOffsetXY;
		uniform sampler2D _ParallaxMap;
		uniform float4 _ParallaxMap_ST;
		uniform float _Parallax;
		uniform float _Saturation;
		uniform float _EnableDetailMask;
		uniform float _ContrastDetailMap;
		uniform float _InvertMask;
		uniform float _SourceMask;
		uniform sampler2D _DetailMask;
		uniform float4 _DetailMask_ST;
		uniform sampler2D _MetallicGlossMapMAHS;
		uniform float4 _MetallicGlossMapMAHS_ST;
		uniform float _SpreadDetailMap;
		uniform float _IntensityMask;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform float _BumpScale;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform float _EmissionIntensity;
		uniform float _AoMask;
		uniform float _ContrastSparkles;
		uniform sampler2D _SparkleMap;
		uniform float _TilingCrystals;
		uniform float _TilingInstance;
		uniform float _Desaturatecrystals;
		uniform float _AmountSparkle;
		uniform float _CrystalsIntensity;
		uniform float _ContrastDotMask;
		uniform sampler2D _DotMask;
		uniform float4 _DotMask_ST;
		uniform float _TilingDotMask;
		uniform float _SpreadDotMask;
		uniform float _IntensityDotMask;
		uniform float _ShadowMask;
		uniform float _AoIntensity;
		uniform float _Metallic;
		uniform float _Glossiness;
		uniform float _InvertABaseColor;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			SurfaceOutputStandard s512 = (SurfaceOutputStandard ) 0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 break26_g623 = uv_MainTex;
			float GlobalTilingX11 = ( _GlobalXYTilingXYZWOffsetXY.x - 1.0 );
			float GlobalTilingY8 = ( _GlobalXYTilingXYZWOffsetXY.y - 1.0 );
			float2 appendResult14_g623 = (float2(( break26_g623.x * GlobalTilingX11 ) , ( break26_g623.y * GlobalTilingY8 )));
			float GlobalOffsetX10 = _GlobalXYTilingXYZWOffsetXY.z;
			float GlobalOffsetY9 = _GlobalXYTilingXYZWOffsetXY.w;
			float2 appendResult13_g623 = (float2(( break26_g623.x + GlobalOffsetX10 ) , ( break26_g623.y + GlobalOffsetY9 )));
			float2 uv_ParallaxMap = i.uv_texcoord * _ParallaxMap_ST.xy + _ParallaxMap_ST.zw;
			float2 break26_g605 = uv_ParallaxMap;
			float2 appendResult14_g605 = (float2(( break26_g605.x * GlobalTilingX11 ) , ( break26_g605.y * GlobalTilingY8 )));
			float2 appendResult13_g605 = (float2(( break26_g605.x + GlobalOffsetX10 ) , ( break26_g605.y + GlobalOffsetY9 )));
			float4 temp_cast_0 = (tex2D( _ParallaxMap, ( appendResult14_g605 + appendResult13_g605 ) ).g).xxxx;
			float2 paralaxOffset36_g604 = ParallaxOffset( temp_cast_0.x , _Parallax , i.viewDir );
			float2 switchResult47_g604 = (((i.ASEVFace>0)?(paralaxOffset36_g604):(0.0)));
			float2 Parallaxe373 = switchResult47_g604;
			float4 tex2DNode7_g622 = tex2D( _MainTex, ( ( appendResult14_g623 + appendResult13_g623 ) + Parallaxe373 ) );
			float clampResult27_g622 = clamp( _Saturation , -1.0 , 100.0 );
			float3 desaturateInitialColor29_g622 = ( _Color * tex2DNode7_g622 ).rgb;
			float desaturateDot29_g622 = dot( desaturateInitialColor29_g622, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar29_g622 = lerp( desaturateInitialColor29_g622, desaturateDot29_g622.xxx, -clampResult27_g622 );
			float4 temp_output_441_0 = CalculateContrast(_Brightness,float4( desaturateVar29_g622 , 0.0 ));
			float4 temp_cast_4 = (1.0).xxxx;
			float2 uv_DetailMask = i.uv_texcoord * _DetailMask_ST.xy + _DetailMask_ST.zw;
			float2 uv_MetallicGlossMapMAHS = i.uv_texcoord * _MetallicGlossMapMAHS_ST.xy + _MetallicGlossMapMAHS_ST.zw;
			float2 break26_g756 = uv_MetallicGlossMapMAHS;
			float2 appendResult14_g756 = (float2(( break26_g756.x * GlobalTilingX11 ) , ( break26_g756.y * GlobalTilingY8 )));
			float2 appendResult13_g756 = (float2(( break26_g756.x + GlobalOffsetX10 ) , ( break26_g756.y + GlobalOffsetY9 )));
			float4 tex2DNode3_g755 = tex2D( _MetallicGlossMapMAHS, ( ( appendResult14_g756 + appendResult13_g756 ) + Parallaxe373 ) );
			float DetailMask426 = tex2DNode3_g755.b;
			float4 temp_cast_5 = (( (( _InvertMask )?( ( 1.0 - (( _SourceMask )?( DetailMask426 ):( tex2D( _DetailMask, uv_DetailMask ).r )) ) ):( (( _SourceMask )?( DetailMask426 ):( tex2D( _DetailMask, uv_DetailMask ).r )) )) + (-1.2 + (_SpreadDetailMap - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)) )).xxxx;
			float4 clampResult38_g760 = clamp( CalculateContrast(( _ContrastDetailMap + 1.0 ),temp_cast_5) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 Mask158 = (( _EnableDetailMask )?( ( clampResult38_g760 * _IntensityMask ) ):( temp_cast_4 ));
			float4 Albedo26 = (( _VisualizeMask )?( Mask158 ):( temp_output_441_0 ));
			s512.Albedo = Albedo26.rgb;
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			float2 break26_g759 = uv_BumpMap;
			float2 appendResult14_g759 = (float2(( break26_g759.x * GlobalTilingX11 ) , ( break26_g759.y * GlobalTilingY8 )));
			float2 appendResult13_g759 = (float2(( break26_g759.x + GlobalOffsetX10 ) , ( break26_g759.y + GlobalOffsetY9 )));
			float3 tex2DNode4_g758 = UnpackScaleNormal( tex2D( _BumpMap, ( ( appendResult14_g759 + appendResult13_g759 ) + Parallaxe373 ) ), _BumpScale );
			float3 Normal27 = tex2DNode4_g758;
			s512.Normal = WorldNormalVector( i , Normal27 );
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float2 break26_g774 = uv_EmissionMap;
			float2 appendResult14_g774 = (float2(( break26_g774.x * GlobalTilingX11 ) , ( break26_g774.y * GlobalTilingY8 )));
			float2 appendResult13_g774 = (float2(( break26_g774.x + GlobalOffsetX10 ) , ( break26_g774.y + GlobalOffsetY9 )));
			float4 temp_output_359_0 = ( _EmissionColor * tex2D( _EmissionMap, ( ( appendResult14_g774 + appendResult13_g774 ) + Parallaxe373 ) ) * _EmissionIntensity );
			float temp_output_135_0_g772 = ( _ContrastSparkles - -1.0 );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos78_g772 = UnityObjectToClipPos( ase_vertex3Pos );
			#if defined(_SPACEPROJECTION_SCREENPOSITION)
				float4 staticSwitch79_g772 = ase_screenPosNorm;
			#elif defined(_SPACEPROJECTION_VERTEXPOSITION)
				float4 staticSwitch79_g772 = unityObjectToClipPos78_g772;
			#else
				float4 staticSwitch79_g772 = ase_screenPosNorm;
			#endif
			float clampResult149_g772 = clamp( _TilingInstance , 0.0 , 1000.0 );
			float2 temp_output_175_0_g772 = Parallaxe373;
			float clampResult49_g772 = clamp( _Desaturatecrystals , 0.0 , 1.0 );
			float3 desaturateInitialColor53_g772 = tex2D( _SparkleMap, ( ( ( staticSwitch79_g772 * _TilingCrystals ) * clampResult149_g772 ) + float4( temp_output_175_0_g772, 0.0 , 0.0 ) ).xy ).rgb;
			float desaturateDot53_g772 = dot( desaturateInitialColor53_g772, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar53_g772 = lerp( desaturateInitialColor53_g772, desaturateDot53_g772.xxx, clampResult49_g772 );
			float clampResult74_g772 = clamp( ( _CrystalsIntensity * 20.0 ) , 0.0 , 100.0 );
			float4 temp_output_67_0_g772 = ( saturate( ( CalculateContrast(temp_output_135_0_g772,float4( desaturateVar53_g772 , 0.0 )) + (( -1.0 - temp_output_135_0_g772 ) + (_AmountSparkle - 0.0) * (0.0 - ( -1.0 - temp_output_135_0_g772 )) / (1.0 - 0.0)) ) ) * clampResult74_g772 );
			float2 uv_DotMask = i.uv_texcoord * _DotMask_ST.xy + _DotMask_ST.zw;
			float4 clampResult118_g772 = clamp( CalculateContrast(( _ContrastDotMask + 1.0 ),( tex2D( _DotMask, ( ( ( uv_DotMask * _TilingDotMask ) * clampResult149_g772 ) + temp_output_175_0_g772 ) ) + (-1.2 + (_SpreadDotMask - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)) )) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 temp_output_119_0_g772 = ( clampResult118_g772 * _IntensityDotMask );
			float3 temp_cast_11 = (1.0).xxx;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult152_g772 = dot( (WorldNormalVector( i , float4( Normal27 , 0.0 ).xyz )) , ase_worldlightDir );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 temp_output_155_0_g772 = ( max( dotResult152_g772 , 0.0 ) * ( ase_lightAtten * ase_lightColor.rgb ) );
			float3 lerpResult169_g772 = lerp( temp_cast_11 , temp_output_155_0_g772 , _ShadowMask);
			float4 temp_output_108_0_g772 = ( temp_output_67_0_g772 * ( temp_output_119_0_g772 * float4( lerpResult169_g772 , 0.0 ) ) );
			float blendOpSrc34_g755 = tex2DNode3_g755.g;
			float blendOpDest34_g755 = ( 1.0 - _AoIntensity );
			float AOG428 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc34_g755 ) * ( 1.0 - blendOpDest34_g755 ) ) ));
			float4 temp_cast_16 = (AOG428).xxxx;
			float4 temp_output_491_0 = ( (( _AoMask )?( ( temp_output_108_0_g772 * temp_cast_16 ) ):( temp_output_108_0_g772 )) * Mask158 );
			#if defined(_SPARKLESOURCE_NONE)
				float4 staticSwitch565 = temp_output_359_0;
			#elif defined(_SPARKLESOURCE_EMISSIVESPARKLES)
				float4 staticSwitch565 = ( temp_output_359_0 + temp_output_491_0 );
			#elif defined(_SPARKLESOURCE_SMOOTHNESSSPARKLES)
				float4 staticSwitch565 = temp_output_359_0;
			#else
				float4 staticSwitch565 = ( temp_output_359_0 + temp_output_491_0 );
			#endif
			float4 temp_output_675_110 = temp_output_119_0_g772;
			float4 temp_output_675_109 = temp_output_67_0_g772;
			#if defined(_VISUALIZESPARKLE_NONE)
				float4 staticSwitch452 = staticSwitch565;
			#elif defined(_VISUALIZESPARKLE_DOTMASK)
				float4 staticSwitch452 = temp_output_675_110;
			#elif defined(_VISUALIZESPARKLE_SPARKLEMAP)
				float4 staticSwitch452 = temp_output_675_109;
			#else
				float4 staticSwitch452 = staticSwitch565;
			#endif
			float4 Emission110 = staticSwitch452;
			s512.Emission = Emission110.rgb;
			float Metallic41 = ( tex2DNode3_g755.r * _Metallic );
			s512.Metallic = Metallic41;
			float BaseColorAlpha46 = (( _InvertABaseColor )?( ( 1.0 - tex2DNode7_g622.a ) ):( tex2DNode7_g622.a ));
			#if defined(_SOURCE_METALLICALPHA)
				float staticSwitch23_g755 = ( tex2DNode3_g755.a * _Glossiness );
			#elif defined(_SOURCE_BASECOLORALPHA)
				float staticSwitch23_g755 = ( _Glossiness * BaseColorAlpha46 );
			#else
				float staticSwitch23_g755 = ( tex2DNode3_g755.a * _Glossiness );
			#endif
			float temp_output_669_7 = staticSwitch23_g755;
			float4 SparklesCrystals575 = temp_output_491_0;
			float clampResult649 = clamp( ( 1.0 - SparklesCrystals575.r ) , 0.0 , 1.0 );
			float lerpResult642 = lerp( SparklesCrystals575.r , temp_output_669_7 , clampResult649);
			#if defined(_SPARKLESOURCE_NONE)
				float staticSwitch576 = temp_output_669_7;
			#elif defined(_SPARKLESOURCE_EMISSIVESPARKLES)
				float staticSwitch576 = temp_output_669_7;
			#elif defined(_SPARKLESOURCE_SMOOTHNESSSPARKLES)
				float staticSwitch576 = ( lerpResult642 * _Glossiness );
			#else
				float staticSwitch576 = temp_output_669_7;
			#endif
			float Smoothness40 = staticSwitch576;
			s512.Smoothness = Smoothness40;
			float AmbientOcclusion94 = AOG428;
			s512.Occlusion = AmbientOcclusion94;

			data.light = gi.light;

			UnityGI gi512 = gi;
			#ifdef UNITY_PASS_FORWARDBASE
			Unity_GlossyEnvironmentData g512 = UnityGlossyEnvironmentSetup( s512.Smoothness, data.worldViewDir, s512.Normal, float3(0,0,0));
			gi512 = UnityGlobalIllumination( data, s512.Occlusion, s512.Normal, g512 );
			#endif

			float3 surfResult512 = LightingStandard ( s512, viewDir, gi512 ).rgb;
			surfResult512 += s512.Emission;

			#ifdef UNITY_PASS_FORWARDADD//512
			surfResult512 -= s512.Emission;
			#endif//512
			c.rgb = surfResult512;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}