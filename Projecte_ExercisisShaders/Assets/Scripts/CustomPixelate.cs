using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

//Needed to let unity serialize this and extend PostProcessEffectSettings
[Serializable]
//Using [PostProcess()] attrib allows us to tell Unity that the class holds postproccessing data. 
[PostProcess(renderer: typeof(CustomPostproPixelate),//First parameter links settings with actual renderer
            PostProcessEvent.AfterStack,//Tells Unity when to execute this postpro in the stack
            "Custom/Pixelate")] //Creates a menu entry for the effect
                                    //Forth parameter that allows to decide if the effect should be shown in scene view
public sealed class PixelateSettings : PostProcessEffectSettings
{
    [Range(1f, 500f), Tooltip("Effect Resolution.")]
    public FloatParameter resolution = new FloatParameter { value = 0.0f };

    [Range(1f, 10f), Tooltip("Effect Pixel Size.")]
    public FloatParameter pixelSize = new FloatParameter { value = 0.0f };
}

public class CustomPostproPixelate : PostProcessEffectRenderer<PixelateSettings>//<T> is the setting type
{
    public override void Render(PostProcessRenderContext context)
    {
        //We get the actual shader property sheet
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Pixelate"));

        //Set the uniform value for our shader
        sheet.properties.SetFloat("_resolution", settings.resolution);
        sheet.properties.SetFloat("_targetPixelSize", settings.pixelSize);

        //We render the scene as a full screen triangle applying the specified shader
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}

