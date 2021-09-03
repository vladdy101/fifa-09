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
float4 Diffuse			: Diffuse = { 0.0f, 1.0f, 0.0f, 1.0f };
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
};

VS_OUTPUT VS(VS_INPUT In)
{
	VS_OUTPUT Out;

	float4 pos			= mul(In.pos, WorldViewProjection);
	Out.colour			= Diffuse * ColourScale + ColourTranslate;

	Out.pos.x			= pos.x;
	Out.pos.y			= pos.y;
	Out.pos.z			= pos.z;
	Out.pos.w			= pos.w;

	// Xray vision
	//Out.colour	= 0.5;
	//Out.colour.a= 0.5;

	return Out;
}

struct PS_INPUT
{
	float4 colour			: COLOR0;
};

float4 PS( PS_INPUT In
	) : COLOR
{
	float4 outputcolour = In.colour;
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
        VertexShader		= compile vs_1_1 VS();
        PixelShader			= compile ps_1_1 PS();
    }  
}

