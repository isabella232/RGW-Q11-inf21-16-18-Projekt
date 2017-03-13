Shader "Sprites/Diffuse Bumped"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		_BumpMap ("Normal Map", 2D) = "bump" {}
	}

	SubShader
	{
		Tags
		{
			"Queue"="Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert nofog keepalpha
		#pragma multi_compile _ PIXELSNAP_ON
		#pragma multi_compile _ ETC1_EXTERNAL_ALPHA

		sampler2D _MainTex;
		fixed4 _Color;
		sampler2D _AlphaTex;
		float _AlphaSplitEnabled;
		sampler2D _BumpMap;


		struct Input
		{
			float2 uv_MainTex;
			fixed4 color;
			float2 uv_BumpMap;
		};


		void vert (inout appdata_full v, out Input o)
		{
			#if defined(PIXELSNAP_ON)
			v.vertex = UnityPixelSnap (v.vertex);
			#endif

			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.color = v.color * _Color;
		}

		fixed4 SampleSpriteTexture (float2 uv)
		{
			fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
			color.a = tex2D (_AlphaTex, uv).r;
#endif //ETC1_EXTERNAL_ALPHA

			return color;
		}

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = SampleSpriteTexture (IN.uv_MainTex) * IN.color;
			o.Albedo = c.rgb * c.a;
			o.Alpha = c.a;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		}
		ENDCG
	}

Fallback "Transparent/VertexLit"
}
