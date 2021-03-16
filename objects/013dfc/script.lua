-- Spirit Panel for MJ & iakona's Spirit Island Mod --
useProgression = false
useAspect = 2

function onLoad(saved_data)
    Color.Add("SoftBlue", Color.new(0.45,0.6,0.7))
    sourceSpirit = getObjectFromGUID("SourceSpirit")
    sourceSpirit.call("load", {obj = self, saved_data = saved_data})
end