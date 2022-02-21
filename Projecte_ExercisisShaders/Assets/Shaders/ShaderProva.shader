Shader "CustomShaders/ShaderProva"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ObjectColor("MainColor", Color) = (0, 0, 0, 1)
        _LightDir("_LightDir", Vector) = (0, 1, 0, 1)
        _LightColor("_LightColor", Color) = (1, 0, 1, 0)

        //struct DirectionalLight {
        //    _Direction("_Direction", float4)
        //    _Color("_LightColor", fixed4)
        //    //_Intensity
        //};
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _ObjectColor;

            float4 _LightDir;
            fixed4 _LightColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float4 lightDir = normalize(_LightDir);
                float diffuseComp = dot(lightDir, i.worldNormal);
                fixed4 finalColor = _ObjectColor * diffuseComp * _LightColor;

                //sample the texture
                fixed4 col = finalColor;
                return col;
            }
            ENDCG
        }
    }
}
