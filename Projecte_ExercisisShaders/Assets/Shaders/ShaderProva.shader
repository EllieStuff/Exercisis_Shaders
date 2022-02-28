Shader "CustomShaders/ShaderProva"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _opacity("Opacity", Float) = 1.0
        _objectColor("Main Color", Color) = (0,0,0,1)
        _directionalLightPos("Directional Light Position", Vector) = (0,1,0,1)
        _directionalLightDir("Directional Light Direction", Vector) = (0,1,0,1)
        _directionalLightColor("Light Color", Color) = (1,1,1,1)
        _specularExp("Specular exponent", Float) = 2.0
    }
        SubShader
        {
            Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
            Blend SrcAlpha OneMinusSrcAlpha

            LOD 100

            Pass
            {
                CGPROGRAM
                //#pragma surface surf Lambert alpha
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
                    float3 wPos : TEXCOORD2;
                };

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float _opacity;

                fixed4 _objectColor;

                float4 _directionalLightPos;
                float4 _directionalLightDir;
                fixed4 _directionalLightColor;

                float _specularExp;

                v2f vert(appdata v)
                {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                    o.worldNormal = UnityObjectToWorldNormal(v.normal);
                    o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                    return o;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    _directionalLightDir = float4(_directionalLightPos.xyz - i.wPos, 1);
                    float4 lightDir = normalize(_directionalLightDir);

                    //Diffuse
                    float diffComp = dot(lightDir, i.worldNormal);

                    //Specular
                    float3 viewVec = normalize(_WorldSpaceCameraPos - i.wPos);
                    float3 halfVec = normalize(viewVec + lightDir);
                    float specularComp = pow(max(dot(halfVec, i.worldNormal), 0), _specularExp);

                    fixed4 col = tex2D(_MainTex, i.uv) * _objectColor * specularComp * diffComp * _directionalLightColor;
                    col.a = _opacity;

                    return col;
                }
                ENDCG
            }
        }
}