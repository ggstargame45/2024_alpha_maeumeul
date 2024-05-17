Shader "Ciconia Studio/CS_Sparkle/URP/Sparkle"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Space(35)][Header(Main Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Space(15)]_GlobalXYTilingXYZWOffsetXY("Global --> XY(TilingXY) - ZW(OffsetXY)", Vector) = (1,1,0,0)
		_BaseColor("Color", Color) = (1,1,1,1)
		[Toggle]_InvertABaseColor1("Invert Alpha", Float) = 0
		_BaseMap("Base Color", 2D) = "white" {}
		_Saturation("Saturation", Float) = 0
		_Brightness("Brightness", Range( 1 , 8)) = 1
		[Space(35)]_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Normal Intensity", Float) = 0.3
		[Space(35)]_MetallicGlossMapMAHS("Mask Map  -->M(R) - Ao(G) - Dm(B) - S(A)", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 2)) = 0
		_Smoothness("Smoothness", Range( 0 , 2)) = 0.5
		[Space(10)][KeywordEnum(MetallicAlpha,BaseColorAlpha)] _Source("Source", Float) = 0
		[Space(15)]_AoIntensity("Ao Intensity", Range( 0 , 2)) = 0
		[Space(35)]_ParallaxMap("Height Map", 2D) = "white" {}
		_Parallax("Height Scale", Range( -0.1 , 0.1)) = 0
		[HDR][Space(45)]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		_EmissionMap("Emission Map", 2D) = "white" {}
		_EmissionIntensity("Intensity", Range( 0 , 2)) = 1
		[Space(35)][Header(Mask Properties________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________)][Toggle]_EnableDetailMask("Enable", Float) = 1
		[Space(15)][Toggle]_VisualizeMask("Visualize Mask", Float) = 0
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
		_TilingCrystals("Tiling", Float) = 1
		_CrystalsIntensity("Intensity", Range( 0 , 5)) = 1
		[Space(15)]_ContrastSparkles("Contrast", Float) = 0
		_AmountSparkle("Amount", Range( 0 , 1)) = 1
		[Space(15)]_Desaturatecrystals("Desaturate", Range( 0 , 1)) = 0
		_ShadowMask("Shadow Mask", Range( 0 , 1)) = 1
		[Toggle]_AoMask("Ao Mask", Float) = 0
		[ASEEnd][Header(Custom Properties)]_TilingInstance("Tiling Instance", Float) = 1

		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		Cull Back
		AlphaToMask Off
		HLSLINCLUDE
		#pragma target 3.0

		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
			    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_FRAG_WORLD_TANGENT
			#define ASE_NEEDS_FRAG_WORLD_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_BITANGENT
			#define ASE_NEEDS_FRAG_WORLD_VIEW_DIR
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma shader_feature_local _VISUALIZESPARKLE_NONE _VISUALIZESPARKLE_DOTMASK _VISUALIZESPARKLE_SPARKLEMAP
			#pragma shader_feature_local _SPARKLESOURCE_NONE _SPARKLESOURCE_EMISSIVESPARKLES _SPARKLESOURCE_SMOOTHNESSSPARKLES
			#pragma shader_feature_local _SPACEPROJECTION_SCREENPOSITION _SPACEPROJECTION_VERTEXPOSITION
			#pragma shader_feature_local _SOURCE_METALLICALPHA _SOURCE_BASECOLORALPHA


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord : TEXCOORD0;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
				#endif
				float4 ase_texcoord7 : TEXCOORD7;
				float4 ase_texcoord8 : TEXCOORD8;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissionColor;
			float4 _EmissionMap_ST;
			float4 _BaseColor;
			float4 _BaseMap_ST;
			float4 _GlobalXYTilingXYZWOffsetXY;
			float4 _ParallaxMap_ST;
			float4 _BumpMap_ST;
			float4 _DotMask_ST;
			float4 _DetailMask_ST;
			float4 _MetallicGlossMapMAHS_ST;
			float _Desaturatecrystals;
			float _AmountSparkle;
			float _CrystalsIntensity;
			float _ContrastDotMask;
			float _TilingDotMask;
			float _SpreadDotMask;
			float _IntensityDotMask;
			float _ShadowMask;
			float _AoIntensity;
			float _Metallic;
			float _TilingInstance;
			float _TilingCrystals;
			float _VisualizeMask;
			float _AoMask;
			float _EmissionIntensity;
			float _Smoothness;
			float _BumpScale;
			float _IntensityMask;
			float _SpreadDetailMap;
			float _SourceMask;
			float _InvertMask;
			float _ContrastDetailMap;
			float _EnableDetailMask;
			float _Saturation;
			float _Parallax;
			float _Brightness;
			float _ContrastSparkles;
			float _InvertABaseColor1;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _BaseMap;
			sampler2D _ParallaxMap;
			sampler2D _DetailMask;
			sampler2D _MetallicGlossMapMAHS;
			sampler2D _BumpMap;
			sampler2D _EmissionMap;
			sampler2D _SparkleMap;
			sampler2D _DotMask;


			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord7.xy = v.texcoord.xy;
				o.ase_texcoord8 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );
				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif
				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
				
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				
				o.clipPos = positionCS;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				o.screenPos = ComputeScreenPos(positionCS);
				#endif
				return o;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN , half ase_vface : VFACE ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif
				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 ScreenPos = IN.screenPos;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif
	
				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 uv_BaseMap = IN.ase_texcoord7.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float2 break26_g796 = uv_BaseMap;
				float GlobalTilingX11 = ( _GlobalXYTilingXYZWOffsetXY.x - 1.0 );
				float GlobalTilingY8 = ( _GlobalXYTilingXYZWOffsetXY.y - 1.0 );
				float2 appendResult14_g796 = (float2(( break26_g796.x * GlobalTilingX11 ) , ( break26_g796.y * GlobalTilingY8 )));
				float GlobalOffsetX10 = _GlobalXYTilingXYZWOffsetXY.z;
				float GlobalOffsetY9 = _GlobalXYTilingXYZWOffsetXY.w;
				float2 appendResult13_g796 = (float2(( break26_g796.x + GlobalOffsetX10 ) , ( break26_g796.y + GlobalOffsetY9 )));
				float2 uv_ParallaxMap = IN.ase_texcoord7.xy * _ParallaxMap_ST.xy + _ParallaxMap_ST.zw;
				float2 break26_g794 = uv_ParallaxMap;
				float2 appendResult14_g794 = (float2(( break26_g794.x * GlobalTilingX11 ) , ( break26_g794.y * GlobalTilingY8 )));
				float2 appendResult13_g794 = (float2(( break26_g794.x + GlobalOffsetX10 ) , ( break26_g794.y + GlobalOffsetY9 )));
				float4 temp_cast_0 = (tex2D( _ParallaxMap, ( appendResult14_g794 + appendResult13_g794 ) ).g).xxxx;
				float3 tanToWorld0 = float3( WorldTangent.x, WorldBiTangent.x, WorldNormal.x );
				float3 tanToWorld1 = float3( WorldTangent.y, WorldBiTangent.y, WorldNormal.y );
				float3 tanToWorld2 = float3( WorldTangent.z, WorldBiTangent.z, WorldNormal.z );
				float3 ase_tanViewDir =  tanToWorld0 * WorldViewDirection.x + tanToWorld1 * WorldViewDirection.y  + tanToWorld2 * WorldViewDirection.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset36_g793 = ParallaxOffset( temp_cast_0.x , _Parallax , ase_tanViewDir );
				float2 switchResult47_g793 = (((ase_vface>0)?(paralaxOffset36_g793):(0.0)));
				float2 Parallaxe373 = switchResult47_g793;
				float4 tex2DNode7_g795 = tex2D( _BaseMap, ( ( appendResult14_g796 + appendResult13_g796 ) + Parallaxe373 ) );
				float clampResult27_g795 = clamp( _Saturation , -1.0 , 100.0 );
				float3 desaturateInitialColor29_g795 = ( _BaseColor * tex2DNode7_g795 ).rgb;
				float desaturateDot29_g795 = dot( desaturateInitialColor29_g795, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar29_g795 = lerp( desaturateInitialColor29_g795, desaturateDot29_g795.xxx, -clampResult27_g795 );
				float4 temp_output_441_0 = CalculateContrast(_Brightness,float4( desaturateVar29_g795 , 0.0 ));
				float4 temp_cast_4 = (1.0).xxxx;
				float2 uv_DetailMask = IN.ase_texcoord7.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
				float2 uv_MetallicGlossMapMAHS = IN.ase_texcoord7.xy * _MetallicGlossMapMAHS_ST.xy + _MetallicGlossMapMAHS_ST.zw;
				float2 break26_g798 = uv_MetallicGlossMapMAHS;
				float2 appendResult14_g798 = (float2(( break26_g798.x * GlobalTilingX11 ) , ( break26_g798.y * GlobalTilingY8 )));
				float2 appendResult13_g798 = (float2(( break26_g798.x + GlobalOffsetX10 ) , ( break26_g798.y + GlobalOffsetY9 )));
				float4 tex2DNode3_g797 = tex2D( _MetallicGlossMapMAHS, ( ( appendResult14_g798 + appendResult13_g798 ) + Parallaxe373 ) );
				float DetailMask426 = tex2DNode3_g797.b;
				float4 temp_cast_5 = (( (( _InvertMask )?( ( 1.0 - (( _SourceMask )?( DetailMask426 ):( tex2D( _DetailMask, uv_DetailMask ).r )) ) ):( (( _SourceMask )?( DetailMask426 ):( tex2D( _DetailMask, uv_DetailMask ).r )) )) + (-1.2 + (_SpreadDetailMap - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)) )).xxxx;
				float4 clampResult38_g799 = clamp( CalculateContrast(( _ContrastDetailMap + 1.0 ),temp_cast_5) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 Mask158 = (( _EnableDetailMask )?( ( clampResult38_g799 * _IntensityMask ) ):( temp_cast_4 ));
				float4 Albedo26 = (( _VisualizeMask )?( Mask158 ):( temp_output_441_0 ));
				
				float2 uv_BumpMap = IN.ase_texcoord7.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				float2 break26_g804 = uv_BumpMap;
				float2 appendResult14_g804 = (float2(( break26_g804.x * GlobalTilingX11 ) , ( break26_g804.y * GlobalTilingY8 )));
				float2 appendResult13_g804 = (float2(( break26_g804.x + GlobalOffsetX10 ) , ( break26_g804.y + GlobalOffsetY9 )));
				float3 unpack4_g803 = UnpackNormalScale( tex2D( _BumpMap, ( ( appendResult14_g804 + appendResult13_g804 ) + Parallaxe373 ) ), _BumpScale );
				unpack4_g803.z = lerp( 1, unpack4_g803.z, saturate(_BumpScale) );
				float3 Normal27 = unpack4_g803;
				
				float2 uv_EmissionMap = IN.ase_texcoord7.xy * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
				float2 break26_g806 = uv_EmissionMap;
				float2 appendResult14_g806 = (float2(( break26_g806.x * GlobalTilingX11 ) , ( break26_g806.y * GlobalTilingY8 )));
				float2 appendResult13_g806 = (float2(( break26_g806.x + GlobalOffsetX10 ) , ( break26_g806.y + GlobalOffsetY9 )));
				float4 temp_output_359_0 = ( _EmissionColor * tex2D( _EmissionMap, ( ( appendResult14_g806 + appendResult13_g806 ) + Parallaxe373 ) ) * _EmissionIntensity );
				float temp_output_135_0_g811 = ( _ContrastSparkles - -1.0 );
				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 unityObjectToClipPos78_g811 = TransformWorldToHClip(TransformObjectToWorld(IN.ase_texcoord8.xyz));
				#if defined(_SPACEPROJECTION_SCREENPOSITION)
				float4 staticSwitch79_g811 = ase_screenPosNorm;
				#elif defined(_SPACEPROJECTION_VERTEXPOSITION)
				float4 staticSwitch79_g811 = unityObjectToClipPos78_g811;
				#else
				float4 staticSwitch79_g811 = ase_screenPosNorm;
				#endif
				float clampResult149_g811 = clamp( _TilingInstance , 0.0 , 1000.0 );
				float2 temp_output_175_0_g811 = Parallaxe373;
				float clampResult49_g811 = clamp( _Desaturatecrystals , 0.0 , 1.0 );
				float3 desaturateInitialColor53_g811 = tex2D( _SparkleMap, ( ( ( staticSwitch79_g811 * _TilingCrystals ) * clampResult149_g811 ) + float4( temp_output_175_0_g811, 0.0 , 0.0 ) ).xy ).rgb;
				float desaturateDot53_g811 = dot( desaturateInitialColor53_g811, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar53_g811 = lerp( desaturateInitialColor53_g811, desaturateDot53_g811.xxx, clampResult49_g811 );
				float clampResult74_g811 = clamp( ( _CrystalsIntensity * 20.0 ) , 0.0 , 100.0 );
				float4 temp_output_67_0_g811 = ( saturate( ( CalculateContrast(temp_output_135_0_g811,float4( desaturateVar53_g811 , 0.0 )) + (( -1.0 - temp_output_135_0_g811 ) + (_AmountSparkle - 0.0) * (0.0 - ( -1.0 - temp_output_135_0_g811 )) / (1.0 - 0.0)) ) ) * clampResult74_g811 );
				float2 uv_DotMask = IN.ase_texcoord7.xy * _DotMask_ST.xy + _DotMask_ST.zw;
				float4 clampResult118_g811 = clamp( CalculateContrast(( _ContrastDotMask + 1.0 ),( tex2D( _DotMask, ( ( ( uv_DotMask * _TilingDotMask ) * clampResult149_g811 ) + temp_output_175_0_g811 ) ) + (-1.2 + (_SpreadDotMask - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)) )) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_119_0_g811 = ( clampResult118_g811 * _IntensityDotMask );
				float3 temp_cast_11 = (1.0).xxx;
				float3 tanNormal161_g811 = float4( Normal27 , 0.0 ).xyz;
				float3 worldNormal161_g811 = float3(dot(tanToWorld0,tanNormal161_g811), dot(tanToWorld1,tanNormal161_g811), dot(tanToWorld2,tanNormal161_g811));
				float dotResult152_g811 = dot( worldNormal161_g811 , _MainLightPosition.xyz );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float3 temp_output_155_0_g811 = ( max( dotResult152_g811 , 0.0 ) * ( ase_lightAtten * _MainLightColor.rgb ) );
				float3 lerpResult169_g811 = lerp( temp_cast_11 , temp_output_155_0_g811 , _ShadowMask);
				float4 temp_output_108_0_g811 = ( temp_output_67_0_g811 * ( temp_output_119_0_g811 * float4( lerpResult169_g811 , 0.0 ) ) );
				float blendOpSrc34_g797 = tex2DNode3_g797.g;
				float blendOpDest34_g797 = ( 1.0 - _AoIntensity );
				float AOG428 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc34_g797 ) * ( 1.0 - blendOpDest34_g797 ) ) ));
				float4 temp_cast_16 = (AOG428).xxxx;
				float4 temp_output_491_0 = ( (( _AoMask )?( ( temp_output_108_0_g811 * temp_cast_16 ) ):( temp_output_108_0_g811 )) * Mask158 );
				#if defined(_SPARKLESOURCE_NONE)
				float4 staticSwitch565 = temp_output_359_0;
				#elif defined(_SPARKLESOURCE_EMISSIVESPARKLES)
				float4 staticSwitch565 = ( temp_output_359_0 + temp_output_491_0 );
				#elif defined(_SPARKLESOURCE_SMOOTHNESSSPARKLES)
				float4 staticSwitch565 = temp_output_359_0;
				#else
				float4 staticSwitch565 = ( temp_output_359_0 + temp_output_491_0 );
				#endif
				float4 DotMask606 = temp_output_119_0_g811;
				float4 SparkleMask599 = temp_output_67_0_g811;
				#if defined(_VISUALIZESPARKLE_NONE)
				float4 staticSwitch452 = staticSwitch565;
				#elif defined(_VISUALIZESPARKLE_DOTMASK)
				float4 staticSwitch452 = DotMask606;
				#elif defined(_VISUALIZESPARKLE_SPARKLEMAP)
				float4 staticSwitch452 = SparkleMask599;
				#else
				float4 staticSwitch452 = staticSwitch565;
				#endif
				float4 Emission110 = staticSwitch452;
				
				float Metallic41 = ( tex2DNode3_g797.r * _Metallic );
				
				float BaseColorAlpha46 = (( _InvertABaseColor1 )?( ( 1.0 - tex2DNode7_g795.a ) ):( tex2DNode7_g795.a ));
				#if defined(_SOURCE_METALLICALPHA)
				float staticSwitch23_g797 = ( tex2DNode3_g797.a * _Smoothness );
				#elif defined(_SOURCE_BASECOLORALPHA)
				float staticSwitch23_g797 = ( _Smoothness * BaseColorAlpha46 );
				#else
				float staticSwitch23_g797 = ( tex2DNode3_g797.a * _Smoothness );
				#endif
				float temp_output_679_7 = staticSwitch23_g797;
				float4 SparklesCrystals575 = temp_output_491_0;
				float clampResult649 = clamp( ( 1.0 - SparklesCrystals575.r ) , 0.0 , 1.0 );
				float lerpResult642 = lerp( SparklesCrystals575.r , temp_output_679_7 , clampResult649);
				#if defined(_SPARKLESOURCE_NONE)
				float staticSwitch576 = temp_output_679_7;
				#elif defined(_SPARKLESOURCE_EMISSIVESPARKLES)
				float staticSwitch576 = temp_output_679_7;
				#elif defined(_SPARKLESOURCE_SMOOTHNESSSPARKLES)
				float staticSwitch576 = ( lerpResult642 * _Smoothness );
				#else
				float staticSwitch576 = temp_output_679_7;
				#endif
				float Smoothness40 = staticSwitch576;
				
				float AmbientOcclusion94 = AOG428;
				
				float3 Albedo = Albedo26.rgb;
				float3 Normal = Normal27;
				float3 Emission = Emission110.rgb;
				float3 Specular = 0.5;
				float Metallic = Metallic41;
				float Smoothness = Smoothness40;
				float Occlusion = AmbientOcclusion94;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
					inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
					inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
					inputData.normalWS = Normal;
					#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				half4 color = UniversalFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				#ifdef _TRANSMISSION_ASE
				{
					float shadow = _TransmissionShadow;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );
					half3 mainTransmission = max(0 , -dot(inputData.normalWS, mainLight.direction)) * mainAtten * Transmission;
					color.rgb += Albedo * mainTransmission;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 transmission = max(0 , -dot(inputData.normalWS, light.direction)) * atten * Transmission;
							color.rgb += Albedo * transmission;
						}
					#endif
				}
				#endif

				#ifdef _TRANSLUCENCY_ASE
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );

					half3 mainLightDir = mainLight.direction + inputData.normalWS * normal;
					half mainVdotL = pow( saturate( dot( inputData.viewDirectionWS, -mainLightDir ) ), scattering );
					half3 mainTranslucency = mainAtten * ( mainVdotL * direct + inputData.bakedGI * ambient ) * Translucency;
					color.rgb += Albedo * mainTranslucency * strength;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 lightDir = light.direction + inputData.normalWS * normal;
							half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );
							half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;
							color.rgb += Albedo * translucency * strength;
						}
					#endif
				}
				#endif

				#ifdef _REFRACTION_ASE
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, WorldNormal ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif
				
				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissionColor;
			float4 _EmissionMap_ST;
			float4 _BaseColor;
			float4 _BaseMap_ST;
			float4 _GlobalXYTilingXYZWOffsetXY;
			float4 _ParallaxMap_ST;
			float4 _BumpMap_ST;
			float4 _DotMask_ST;
			float4 _DetailMask_ST;
			float4 _MetallicGlossMapMAHS_ST;
			float _Desaturatecrystals;
			float _AmountSparkle;
			float _CrystalsIntensity;
			float _ContrastDotMask;
			float _TilingDotMask;
			float _SpreadDotMask;
			float _IntensityDotMask;
			float _ShadowMask;
			float _AoIntensity;
			float _Metallic;
			float _TilingInstance;
			float _TilingCrystals;
			float _VisualizeMask;
			float _AoMask;
			float _EmissionIntensity;
			float _Smoothness;
			float _BumpScale;
			float _IntensityMask;
			float _SpreadDetailMap;
			float _SourceMask;
			float _InvertMask;
			float _ContrastDetailMap;
			float _EnableDetailMask;
			float _Saturation;
			float _Parallax;
			float _Brightness;
			float _ContrastSparkles;
			float _InvertABaseColor1;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = clipPos;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );
				
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissionColor;
			float4 _EmissionMap_ST;
			float4 _BaseColor;
			float4 _BaseMap_ST;
			float4 _GlobalXYTilingXYZWOffsetXY;
			float4 _ParallaxMap_ST;
			float4 _BumpMap_ST;
			float4 _DotMask_ST;
			float4 _DetailMask_ST;
			float4 _MetallicGlossMapMAHS_ST;
			float _Desaturatecrystals;
			float _AmountSparkle;
			float _CrystalsIntensity;
			float _ContrastDotMask;
			float _TilingDotMask;
			float _SpreadDotMask;
			float _IntensityDotMask;
			float _ShadowMask;
			float _AoIntensity;
			float _Metallic;
			float _TilingInstance;
			float _TilingCrystals;
			float _VisualizeMask;
			float _AoMask;
			float _EmissionIntensity;
			float _Smoothness;
			float _BumpScale;
			float _IntensityMask;
			float _SpreadDetailMap;
			float _SourceMask;
			float _InvertMask;
			float _ContrastDetailMap;
			float _EnableDetailMask;
			float _Saturation;
			float _Parallax;
			float _Brightness;
			float _ContrastSparkles;
			float _InvertABaseColor1;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma shader_feature_local _VISUALIZESPARKLE_NONE _VISUALIZESPARKLE_DOTMASK _VISUALIZESPARKLE_SPARKLEMAP
			#pragma shader_feature_local _SPARKLESOURCE_NONE _SPARKLESOURCE_EMISSIVESPARKLES _SPARKLESOURCE_SMOOTHNESSSPARKLES
			#pragma shader_feature_local _SPACEPROJECTION_SCREENPOSITION _SPACEPROJECTION_VERTEXPOSITION
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissionColor;
			float4 _EmissionMap_ST;
			float4 _BaseColor;
			float4 _BaseMap_ST;
			float4 _GlobalXYTilingXYZWOffsetXY;
			float4 _ParallaxMap_ST;
			float4 _BumpMap_ST;
			float4 _DotMask_ST;
			float4 _DetailMask_ST;
			float4 _MetallicGlossMapMAHS_ST;
			float _Desaturatecrystals;
			float _AmountSparkle;
			float _CrystalsIntensity;
			float _ContrastDotMask;
			float _TilingDotMask;
			float _SpreadDotMask;
			float _IntensityDotMask;
			float _ShadowMask;
			float _AoIntensity;
			float _Metallic;
			float _TilingInstance;
			float _TilingCrystals;
			float _VisualizeMask;
			float _AoMask;
			float _EmissionIntensity;
			float _Smoothness;
			float _BumpScale;
			float _IntensityMask;
			float _SpreadDetailMap;
			float _SourceMask;
			float _InvertMask;
			float _ContrastDetailMap;
			float _EnableDetailMask;
			float _Saturation;
			float _Parallax;
			float _Brightness;
			float _ContrastSparkles;
			float _InvertABaseColor1;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _BaseMap;
			sampler2D _ParallaxMap;
			sampler2D _DetailMask;
			sampler2D _MetallicGlossMapMAHS;
			sampler2D _EmissionMap;
			sampler2D _SparkleMap;
			sampler2D _DotMask;
			sampler2D _BumpMap;


			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord6 = screenPos;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_texcoord7 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN , half ase_vface : VFACE ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 uv_BaseMap = IN.ase_texcoord2.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float2 break26_g796 = uv_BaseMap;
				float GlobalTilingX11 = ( _GlobalXYTilingXYZWOffsetXY.x - 1.0 );
				float GlobalTilingY8 = ( _GlobalXYTilingXYZWOffsetXY.y - 1.0 );
				float2 appendResult14_g796 = (float2(( break26_g796.x * GlobalTilingX11 ) , ( break26_g796.y * GlobalTilingY8 )));
				float GlobalOffsetX10 = _GlobalXYTilingXYZWOffsetXY.z;
				float GlobalOffsetY9 = _GlobalXYTilingXYZWOffsetXY.w;
				float2 appendResult13_g796 = (float2(( break26_g796.x + GlobalOffsetX10 ) , ( break26_g796.y + GlobalOffsetY9 )));
				float2 uv_ParallaxMap = IN.ase_texcoord2.xy * _ParallaxMap_ST.xy + _ParallaxMap_ST.zw;
				float2 break26_g794 = uv_ParallaxMap;
				float2 appendResult14_g794 = (float2(( break26_g794.x * GlobalTilingX11 ) , ( break26_g794.y * GlobalTilingY8 )));
				float2 appendResult13_g794 = (float2(( break26_g794.x + GlobalOffsetX10 ) , ( break26_g794.y + GlobalOffsetY9 )));
				float4 temp_cast_0 = (tex2D( _ParallaxMap, ( appendResult14_g794 + appendResult13_g794 ) ).g).xxxx;
				float3 ase_worldTangent = IN.ase_texcoord3.xyz;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset36_g793 = ParallaxOffset( temp_cast_0.x , _Parallax , ase_tanViewDir );
				float2 switchResult47_g793 = (((ase_vface>0)?(paralaxOffset36_g793):(0.0)));
				float2 Parallaxe373 = switchResult47_g793;
				float4 tex2DNode7_g795 = tex2D( _BaseMap, ( ( appendResult14_g796 + appendResult13_g796 ) + Parallaxe373 ) );
				float clampResult27_g795 = clamp( _Saturation , -1.0 , 100.0 );
				float3 desaturateInitialColor29_g795 = ( _BaseColor * tex2DNode7_g795 ).rgb;
				float desaturateDot29_g795 = dot( desaturateInitialColor29_g795, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar29_g795 = lerp( desaturateInitialColor29_g795, desaturateDot29_g795.xxx, -clampResult27_g795 );
				float4 temp_output_441_0 = CalculateContrast(_Brightness,float4( desaturateVar29_g795 , 0.0 ));
				float4 temp_cast_4 = (1.0).xxxx;
				float2 uv_DetailMask = IN.ase_texcoord2.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
				float2 uv_MetallicGlossMapMAHS = IN.ase_texcoord2.xy * _MetallicGlossMapMAHS_ST.xy + _MetallicGlossMapMAHS_ST.zw;
				float2 break26_g798 = uv_MetallicGlossMapMAHS;
				float2 appendResult14_g798 = (float2(( break26_g798.x * GlobalTilingX11 ) , ( break26_g798.y * GlobalTilingY8 )));
				float2 appendResult13_g798 = (float2(( break26_g798.x + GlobalOffsetX10 ) , ( break26_g798.y + GlobalOffsetY9 )));
				float4 tex2DNode3_g797 = tex2D( _MetallicGlossMapMAHS, ( ( appendResult14_g798 + appendResult13_g798 ) + Parallaxe373 ) );
				float DetailMask426 = tex2DNode3_g797.b;
				float4 temp_cast_5 = (( (( _InvertMask )?( ( 1.0 - (( _SourceMask )?( DetailMask426 ):( tex2D( _DetailMask, uv_DetailMask ).r )) ) ):( (( _SourceMask )?( DetailMask426 ):( tex2D( _DetailMask, uv_DetailMask ).r )) )) + (-1.2 + (_SpreadDetailMap - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)) )).xxxx;
				float4 clampResult38_g799 = clamp( CalculateContrast(( _ContrastDetailMap + 1.0 ),temp_cast_5) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 Mask158 = (( _EnableDetailMask )?( ( clampResult38_g799 * _IntensityMask ) ):( temp_cast_4 ));
				float4 Albedo26 = (( _VisualizeMask )?( Mask158 ):( temp_output_441_0 ));
				
				float2 uv_EmissionMap = IN.ase_texcoord2.xy * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
				float2 break26_g806 = uv_EmissionMap;
				float2 appendResult14_g806 = (float2(( break26_g806.x * GlobalTilingX11 ) , ( break26_g806.y * GlobalTilingY8 )));
				float2 appendResult13_g806 = (float2(( break26_g806.x + GlobalOffsetX10 ) , ( break26_g806.y + GlobalOffsetY9 )));
				float4 temp_output_359_0 = ( _EmissionColor * tex2D( _EmissionMap, ( ( appendResult14_g806 + appendResult13_g806 ) + Parallaxe373 ) ) * _EmissionIntensity );
				float temp_output_135_0_g811 = ( _ContrastSparkles - -1.0 );
				float4 screenPos = IN.ase_texcoord6;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float4 unityObjectToClipPos78_g811 = TransformWorldToHClip(TransformObjectToWorld(IN.ase_texcoord7.xyz));
				#if defined(_SPACEPROJECTION_SCREENPOSITION)
				float4 staticSwitch79_g811 = ase_screenPosNorm;
				#elif defined(_SPACEPROJECTION_VERTEXPOSITION)
				float4 staticSwitch79_g811 = unityObjectToClipPos78_g811;
				#else
				float4 staticSwitch79_g811 = ase_screenPosNorm;
				#endif
				float clampResult149_g811 = clamp( _TilingInstance , 0.0 , 1000.0 );
				float2 temp_output_175_0_g811 = Parallaxe373;
				float clampResult49_g811 = clamp( _Desaturatecrystals , 0.0 , 1.0 );
				float3 desaturateInitialColor53_g811 = tex2D( _SparkleMap, ( ( ( staticSwitch79_g811 * _TilingCrystals ) * clampResult149_g811 ) + float4( temp_output_175_0_g811, 0.0 , 0.0 ) ).xy ).rgb;
				float desaturateDot53_g811 = dot( desaturateInitialColor53_g811, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar53_g811 = lerp( desaturateInitialColor53_g811, desaturateDot53_g811.xxx, clampResult49_g811 );
				float clampResult74_g811 = clamp( ( _CrystalsIntensity * 20.0 ) , 0.0 , 100.0 );
				float4 temp_output_67_0_g811 = ( saturate( ( CalculateContrast(temp_output_135_0_g811,float4( desaturateVar53_g811 , 0.0 )) + (( -1.0 - temp_output_135_0_g811 ) + (_AmountSparkle - 0.0) * (0.0 - ( -1.0 - temp_output_135_0_g811 )) / (1.0 - 0.0)) ) ) * clampResult74_g811 );
				float2 uv_DotMask = IN.ase_texcoord2.xy * _DotMask_ST.xy + _DotMask_ST.zw;
				float4 clampResult118_g811 = clamp( CalculateContrast(( _ContrastDotMask + 1.0 ),( tex2D( _DotMask, ( ( ( uv_DotMask * _TilingDotMask ) * clampResult149_g811 ) + temp_output_175_0_g811 ) ) + (-1.2 + (_SpreadDotMask - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)) )) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_output_119_0_g811 = ( clampResult118_g811 * _IntensityDotMask );
				float3 temp_cast_11 = (1.0).xxx;
				float2 uv_BumpMap = IN.ase_texcoord2.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;
				float2 break26_g804 = uv_BumpMap;
				float2 appendResult14_g804 = (float2(( break26_g804.x * GlobalTilingX11 ) , ( break26_g804.y * GlobalTilingY8 )));
				float2 appendResult13_g804 = (float2(( break26_g804.x + GlobalOffsetX10 ) , ( break26_g804.y + GlobalOffsetY9 )));
				float3 unpack4_g803 = UnpackNormalScale( tex2D( _BumpMap, ( ( appendResult14_g804 + appendResult13_g804 ) + Parallaxe373 ) ), _BumpScale );
				unpack4_g803.z = lerp( 1, unpack4_g803.z, saturate(_BumpScale) );
				float3 Normal27 = unpack4_g803;
				float3 tanNormal161_g811 = float4( Normal27 , 0.0 ).xyz;
				float3 worldNormal161_g811 = float3(dot(tanToWorld0,tanNormal161_g811), dot(tanToWorld1,tanNormal161_g811), dot(tanToWorld2,tanNormal161_g811));
				float dotResult152_g811 = dot( worldNormal161_g811 , _MainLightPosition.xyz );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float3 temp_output_155_0_g811 = ( max( dotResult152_g811 , 0.0 ) * ( ase_lightAtten * _MainLightColor.rgb ) );
				float3 lerpResult169_g811 = lerp( temp_cast_11 , temp_output_155_0_g811 , _ShadowMask);
				float4 temp_output_108_0_g811 = ( temp_output_67_0_g811 * ( temp_output_119_0_g811 * float4( lerpResult169_g811 , 0.0 ) ) );
				float blendOpSrc34_g797 = tex2DNode3_g797.g;
				float blendOpDest34_g797 = ( 1.0 - _AoIntensity );
				float AOG428 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc34_g797 ) * ( 1.0 - blendOpDest34_g797 ) ) ));
				float4 temp_cast_16 = (AOG428).xxxx;
				float4 temp_output_491_0 = ( (( _AoMask )?( ( temp_output_108_0_g811 * temp_cast_16 ) ):( temp_output_108_0_g811 )) * Mask158 );
				#if defined(_SPARKLESOURCE_NONE)
				float4 staticSwitch565 = temp_output_359_0;
				#elif defined(_SPARKLESOURCE_EMISSIVESPARKLES)
				float4 staticSwitch565 = ( temp_output_359_0 + temp_output_491_0 );
				#elif defined(_SPARKLESOURCE_SMOOTHNESSSPARKLES)
				float4 staticSwitch565 = temp_output_359_0;
				#else
				float4 staticSwitch565 = ( temp_output_359_0 + temp_output_491_0 );
				#endif
				float4 DotMask606 = temp_output_119_0_g811;
				float4 SparkleMask599 = temp_output_67_0_g811;
				#if defined(_VISUALIZESPARKLE_NONE)
				float4 staticSwitch452 = staticSwitch565;
				#elif defined(_VISUALIZESPARKLE_DOTMASK)
				float4 staticSwitch452 = DotMask606;
				#elif defined(_VISUALIZESPARKLE_SPARKLEMAP)
				float4 staticSwitch452 = SparkleMask599;
				#else
				float4 staticSwitch452 = staticSwitch565;
				#endif
				float4 Emission110 = staticSwitch452;
				
				
				float3 Albedo = Albedo26.rgb;
				float3 Emission = Emission110.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
				
				return MetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 70301

			#pragma enable_d3d11_debug_symbols
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissionColor;
			float4 _EmissionMap_ST;
			float4 _BaseColor;
			float4 _BaseMap_ST;
			float4 _GlobalXYTilingXYZWOffsetXY;
			float4 _ParallaxMap_ST;
			float4 _BumpMap_ST;
			float4 _DotMask_ST;
			float4 _DetailMask_ST;
			float4 _MetallicGlossMapMAHS_ST;
			float _Desaturatecrystals;
			float _AmountSparkle;
			float _CrystalsIntensity;
			float _ContrastDotMask;
			float _TilingDotMask;
			float _SpreadDotMask;
			float _IntensityDotMask;
			float _ShadowMask;
			float _AoIntensity;
			float _Metallic;
			float _TilingInstance;
			float _TilingCrystals;
			float _VisualizeMask;
			float _AoMask;
			float _EmissionIntensity;
			float _Smoothness;
			float _BumpScale;
			float _IntensityMask;
			float _SpreadDetailMap;
			float _SourceMask;
			float _InvertMask;
			float _ContrastDetailMap;
			float _EnableDetailMask;
			float _Saturation;
			float _Parallax;
			float _Brightness;
			float _ContrastSparkles;
			float _InvertABaseColor1;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _BaseMap;
			sampler2D _ParallaxMap;
			sampler2D _DetailMask;
			sampler2D _MetallicGlossMapMAHS;


			inline float2 ParallaxOffset( half h, half height, half3 viewDir )
			{
				h = h * height - height/2.0;
				float3 v = normalize( viewDir );
				v.z += 0.42;
				return h* (v.xy / v.z);
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN , half ase_vface : VFACE ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 uv_BaseMap = IN.ase_texcoord2.xy * _BaseMap_ST.xy + _BaseMap_ST.zw;
				float2 break26_g796 = uv_BaseMap;
				float GlobalTilingX11 = ( _GlobalXYTilingXYZWOffsetXY.x - 1.0 );
				float GlobalTilingY8 = ( _GlobalXYTilingXYZWOffsetXY.y - 1.0 );
				float2 appendResult14_g796 = (float2(( break26_g796.x * GlobalTilingX11 ) , ( break26_g796.y * GlobalTilingY8 )));
				float GlobalOffsetX10 = _GlobalXYTilingXYZWOffsetXY.z;
				float GlobalOffsetY9 = _GlobalXYTilingXYZWOffsetXY.w;
				float2 appendResult13_g796 = (float2(( break26_g796.x + GlobalOffsetX10 ) , ( break26_g796.y + GlobalOffsetY9 )));
				float2 uv_ParallaxMap = IN.ase_texcoord2.xy * _ParallaxMap_ST.xy + _ParallaxMap_ST.zw;
				float2 break26_g794 = uv_ParallaxMap;
				float2 appendResult14_g794 = (float2(( break26_g794.x * GlobalTilingX11 ) , ( break26_g794.y * GlobalTilingY8 )));
				float2 appendResult13_g794 = (float2(( break26_g794.x + GlobalOffsetX10 ) , ( break26_g794.y + GlobalOffsetY9 )));
				float4 temp_cast_0 = (tex2D( _ParallaxMap, ( appendResult14_g794 + appendResult13_g794 ) ).g).xxxx;
				float3 ase_worldTangent = IN.ase_texcoord3.xyz;
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 paralaxOffset36_g793 = ParallaxOffset( temp_cast_0.x , _Parallax , ase_tanViewDir );
				float2 switchResult47_g793 = (((ase_vface>0)?(paralaxOffset36_g793):(0.0)));
				float2 Parallaxe373 = switchResult47_g793;
				float4 tex2DNode7_g795 = tex2D( _BaseMap, ( ( appendResult14_g796 + appendResult13_g796 ) + Parallaxe373 ) );
				float clampResult27_g795 = clamp( _Saturation , -1.0 , 100.0 );
				float3 desaturateInitialColor29_g795 = ( _BaseColor * tex2DNode7_g795 ).rgb;
				float desaturateDot29_g795 = dot( desaturateInitialColor29_g795, float3( 0.299, 0.587, 0.114 ));
				float3 desaturateVar29_g795 = lerp( desaturateInitialColor29_g795, desaturateDot29_g795.xxx, -clampResult27_g795 );
				float4 temp_output_441_0 = CalculateContrast(_Brightness,float4( desaturateVar29_g795 , 0.0 ));
				float4 temp_cast_4 = (1.0).xxxx;
				float2 uv_DetailMask = IN.ase_texcoord2.xy * _DetailMask_ST.xy + _DetailMask_ST.zw;
				float2 uv_MetallicGlossMapMAHS = IN.ase_texcoord2.xy * _MetallicGlossMapMAHS_ST.xy + _MetallicGlossMapMAHS_ST.zw;
				float2 break26_g798 = uv_MetallicGlossMapMAHS;
				float2 appendResult14_g798 = (float2(( break26_g798.x * GlobalTilingX11 ) , ( break26_g798.y * GlobalTilingY8 )));
				float2 appendResult13_g798 = (float2(( break26_g798.x + GlobalOffsetX10 ) , ( break26_g798.y + GlobalOffsetY9 )));
				float4 tex2DNode3_g797 = tex2D( _MetallicGlossMapMAHS, ( ( appendResult14_g798 + appendResult13_g798 ) + Parallaxe373 ) );
				float DetailMask426 = tex2DNode3_g797.b;
				float4 temp_cast_5 = (( (( _InvertMask )?( ( 1.0 - (( _SourceMask )?( DetailMask426 ):( tex2D( _DetailMask, uv_DetailMask ).r )) ) ):( (( _SourceMask )?( DetailMask426 ):( tex2D( _DetailMask, uv_DetailMask ).r )) )) + (-1.2 + (_SpreadDetailMap - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)) )).xxxx;
				float4 clampResult38_g799 = clamp( CalculateContrast(( _ContrastDetailMap + 1.0 ),temp_cast_5) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 Mask158 = (( _EnableDetailMask )?( ( clampResult38_g799 * _IntensityMask ) ):( temp_cast_4 ));
				float4 Albedo26 = (( _VisualizeMask )?( Mask158 ):( temp_output_441_0 ));
				
				
				float3 Albedo = Albedo26.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				half4 color = half4( Albedo, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}
		
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}