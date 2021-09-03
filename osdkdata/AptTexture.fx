//
// AptGouraud.fx
//
// Note: This effect file works with EffectEdit.
//

// transformations
matrix WorldViewProjection	: WorldViewProjection =
{
	1.0f, 0.0f, 0.0f, 0.0f,
	0.0f, 1.0f, 0.0f, 0.0f,
	0.0f, 0.0f, 1.0f, 0.0f,
	0.0f, 0.0f, 0.0f, 1.0f
};
float4 TextureMatrix[2];
float4 Diffuse			: Diffuse = { 1.0f, 1.0f, 1.0f, 1.0f };
float4 ColourScale		= {1.0f, 1.0f, 1.0f, 1.0f};
float4 ColourTranslate	= {0.0f, 0.0f, 0.0f, 0.0f};

struct VS_INPUT
{
	float4 pos		: POSITION;
};

struct VS_OUTPUT
{
	float4 pos				: POSITION;
	float4 colour			: COLOR0;
	float2 uv				: TEXCOORD0;
};

VS_OUTPUT VS(VS_INPUT In)
{
	VS_OUTPUT Out;

	float4 pos			= mul(In.pos, WorldViewProjection);
	Out.colour			= Diffuse * ColourScale;

	Out.pos.x			= pos.x;
	Out.pos.y			= pos.y;
	Out.pos.z			= pos.z;
	Out.pos.w			= pos.w;

	pos = In.pos;
	float4 uv;
	uv.x				= dot(pos, TextureMatrix[0]);
	uv.y				= dot(pos, TextureMatrix[1]);
	Out.uv.x = uv.x;
	Out.uv.y = uv.y;

	//Out.colour = 0.7;

	return Out;
}

texture Texture;
sampler Sampler = sampler_state
{
	Texture		= <Texture>;
	MipFilter	= NONE; 
	
	// [adave] - This must be point to prevent padded part of texture from bleeding in.
	// We should bilinear the filter on texture load, instead of during draw.
	MinFilter	= LINEAR;
	MagFilter	= LINEAR;

	// [ ] [adave] - Can't rely on c++ code to set this. Somehow, sampler state gets set to WRAP someplace,
	//               which causes vertical lines to appear in cafe's debug->popup windows.
	AddressU	= CLAMP;
	AddressV	= CLAMP;
};

struct PS_INPUT
{
	float4 colour			: COLOR0;
	float2 uv				: TEXCOORD0;
};

float4 PS( PS_INPUT In
	) : COLOR
{
	float4 texturecolour = tex2D(Sampler, In.uv);
	float4 outputcolour = In.colour * texturecolour + ColourTranslate;
	return outputcolour;
}

technique t0
{
    pass p0
    {
		FillMode			= SOLID;
		AlphaBlendEnable	= TRUE;
		SrcBlend			= SrcAlpha;
		DestBlend			= InvSrcAlpha;
		CullMode			= NONE;
		ZEnable				= FALSE;

        // shaders
        VertexShader = compile vs_1_1 VS();
        PixelShader  = compile ps_1_1 PS();
    }  
}
