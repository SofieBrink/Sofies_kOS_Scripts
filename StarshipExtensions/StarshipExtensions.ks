//User Settable Variables
local ShowRvacButton is false. //set this to true if you want a button to toggle the Rvac's
local RvacTag is "Rvac". //enter the tag given to the Rvac's here
local GUI_X is -60. //X coordinate for GUI.
local GUI_Y is 80. //Y coordinate for GUI.
local FrontAngleDefault is 60. //Default angle for the front flaps
local RearAngleDefault is 60. //Default angle for the aft flaps
local AuthLimitDefault is 15. //Default Authority limiter.
local AbortReset is true. //Disable this to disable the abort action group ressetting the script. Mutually exclusive with AbortEngineStart. AbortReset takes priority if both true.
local AbortEngineStart is false. //This turns on the starship engines when the abort key is pressed. Mutually exclusive with AbortReset. Only 1 can be true. AbortReset Takes Priority if True.

//functions
Function CreateGUI { //I'm pretty bad at creating GUI's but it works.
    clearguis().
    clearvecdraws().
    global StarshipGUI is GUI(300).
    local temp1 is StarshipGUI:addhlayout().
    local temp2 is temp1:addlabel("       Starship Controls").
    set temp2:style:ALIGN to "CENTER".
    local MinimizeButton is temp1:addcheckbox("", true).
    set MinimizeButton:style:ALIGN to "RIGHT".
    local MainGUI is StarshipGUI:addvlayout().

    set MinimizeButton:onclick to {if MinimizeButton:pressed{MainGUI:show().}else{MainGUI:hide().} }.
    set StarshipGUI:x to GUI_X.
    set StarshipGUI:y to GUI_Y.
    
    local temp1 is MainGUI:addhlayout().
    temp1:addspacing(130).
    set Engine1Button to temp1:addcheckbox("", false).
    local temp1 is MainGUI:addhlayout().
    temp1:addspacing(110).
    set Engine2Button to temp1:addcheckbox("", false).
    temp1:addspacing(10).
    set Engine3Button to temp1:addcheckbox("", false).
    local RvacLayout is MainGUI:addhlayout().
    if not(ShowRvacButton) {
        RvacLayout:hide().
    }
    RvacLayout:addlabel("Rvac's: ").
    set RvacButton to RvacLayout:addcheckbox("", false).
    set RvacButton:style:align to "RIGHT".

    local temp1 is MainGUI:addhlayout().
    temp1:addlabel("Front Angle: ").
    set FrontFlapSlider to temp1:addhslider().
    set FrontFlapSlider:min to 0.
    set FrontFlapSlider:max to 90.
    set FrontFlapSlider:value to 60.
    set FrontFlapSlider:style:align to "RIGHT".
    set FrontFlapSlider:style:width to 98.
    local temp1 is MainGUI:addhlayout().
    temp1:addlabel("Rear Angle: ").
    set RearFlapSlider to temp1:addhslider().
    set RearFlapSlider:min to 0.
    set RearFlapSlider:max to 90.
    set RearFlapSlider:value to 60.
    set RearFlapSlider:style:align to "RIGHT".
    set RearFlapSlider:style:width to 98.
    local temp1 is MainGUI:addhlayout().
    temp1:addlabel("Link Sliders: ").
    set SliderLinkButton to temp1:addcheckbox("", false).
    local temp1 is MainGUI:addhlayout().
    temp1:addlabel("Authority: ").
    set AuthSlider to temp1:addhslider().
    set AuthSlider:min to 0.
    set AuthSlider:max to 40.
    set AuthSlider:value to 15.
    set AuthSlider:style:align to "RIGHT".
    set AuthSlider:style:width to 98.
    local temp1 is MainGUI:addhlayout().
    temp1:addlabel("Landing Assist: ").
    set LandingAssistButton to temp1:addcheckbox("", false).
    set LandingAssistButton:style:align to "RIGHT".
    set temp3 to MainGUI:addhlayout().
    temp3:addlabel("SAS Control: ").
    set SASControlButton to temp3:addcheckbox("", false).
    set SASControlButton:style:align to "RIGHT".
    temp3:hide().


    set FrontFlapSlider:onchange to {parameter val. if SliderLinkButton:pressed{if RearFlapSlider:value = FrontFlapSlider:value{}else{set RearFlapSlider:value to FrontFlapSlider:value.}} FlapControl(FrontFlapSlider:value, RearFlapSlider:value, AuthSlider:value).}.
    set RearFlapSlider:onchange to {parameter val. if SliderLinkButton:pressed{if RearFlapSlider:value = FrontFlapSlider:value{}else{set FrontFlapSlider:value to RearFlapSlider:value.}} FlapControl(FrontFlapSlider:value, RearFlapSlider:value, AuthSlider:value).}.
    set AuthSlider:onchange to {parameter val. FlapControl(FrontFlapSlider:value, RearFlapSlider:value, AuthSlider:value).}.

    set Engine1Button:onclick to {SLEngineControl(Engine1Button:pressed, Engine2Button:pressed, Engine3Button:pressed).}.
    set Engine2Button:onclick to {SLEngineControl(Engine1Button:pressed, Engine2Button:pressed, Engine3Button:pressed).}.
    set Engine3Button:onclick to {SLEngineControl(Engine1Button:pressed, Engine2Button:pressed, Engine3Button:pressed).}.

    set RvacButton:onclick to {if ShowRvacButton { VacEngineControl(RvacButton:pressed). }}.

    set LandingAssistButton:onclick to {LandingAssist().}.
    StarshipGUI:show().

}



Function FlapControl{
    local AftFlaps is ship:partstaggedpattern("AftFlap").
    local FrontFlaps is ship:partstaggedpattern("FrontFlap").
    parameter FrontDeployAngle.
    parameter AftDeployAngle.
    parameter AuthLimit.
    for Flap in AftFlaps {
        Flap:getmodule("ModuleTundraControlSurface"):setfield("Deploy Angle", AftDeployAngle).
        Flap:getmodule("ModuleTundraControlSurface"):setfield("Authority Limiter", AuthLimit).
    }
    for Flap in FrontFlaps {
        Flap:getmodule("ModuleTundraControlSurface"):setfield("Deploy Angle", FrontDeployAngle).
        Flap:getmodule("ModuleTundraControlSurface"):setfield("Authority Limiter", AuthLimit).
    }
}
function SLEngineControl {
    parameter Eng1.
    parameter Eng2.
    parameter Eng3.
    local Engine1 is ship:partstaggedpattern("Engine 1").
    local Engine2 is ship:partstaggedpattern("Engine 2").
    local Engine3 is ship:partstaggedpattern("Engine 3").
    if Eng1{
        for eng in Engine1 {
        Eng:getmodule("ModuleGimbal"):setfield("gimbal", 0).
        Eng:Activate.
        }
    }
    else {
        for eng in Engine1 {
        Eng:getmodule("ModuleGimbal"):setfield("gimbal", 1).
        Eng:Shutdown.
        }
    }
    
    if Eng2{
        for eng in Engine2 {
        Eng:getmodule("ModuleGimbal"):setfield("gimbal", 0).
        Eng:Activate.
        }
    }
    else {
        for eng in Engine2 {
        Eng:getmodule("ModuleGimbal"):setfield("gimbal", 1).
        Eng:Shutdown.
        }
    }

    if Eng3{
        for eng in Engine3 {
        Eng:getmodule("ModuleGimbal"):setfield("gimbal", 0).
        Eng:Activate.
        }
    }
    else {
        for eng in Engine3 {
        Eng:getmodule("ModuleGimbal"):setfield("gimbal", 1).
        Eng:Shutdown.
        }
    }
}
function VacEngineControl {
    parameter OnOff.
    local VacuumEngines is ship:partstaggedpattern(RvacTag).
    if OnOff {
        for eng in VacuumEngines {
        Eng:Activate.
        }
    }
    else {
        for eng in VacuumEngines {
        Eng:Shutdown.
        }
    }
}

Function LandingAssist {
    if LandingAssistButton:pressed = false or ship:verticalspeed > 0 {
        set LandingAssistButton:pressed to false.
        temp3:hide().
        return 0.
    }
    set SASControlButton:pressed to True.
    temp3:show().
    local FrontPrevAngle is FrontFlapSlider:value.
    local RearPrevAngle is RearFlapSlider:value.
    until throttle > 0 or LandingAssistButton:pressed = false {
        FlapControl(FrontFlapSlider:value, RearFlapSlider:value, AuthSlider:value).
        SLEngineControl(Engine1Button:pressed, Engine2Button:pressed, Engine3Button:pressed).
        if SliderLinkButton:pressed {
            if not(FrontPrevAngle = FrontFlapSlider:value) {
                set RearFlapSlider:value to FrontFlapSlider:value.
            }
            else if not(RearPrevAngle = RearFlapSlider:value) {
                set FrontFlapSlider:value to RearFlapSlider:value.
            }
        }
        set FrontPrevAngle to FrontFlapSlider:value.
        set RearPrevAngle to RearFlapSlider:value.
        wait 0.05.
    }
    if LandingAssistButton:pressed = false {
        temp3:hide().
        set SASControlButton:pressed to True.
        return 0.
    }
    set SliderLinkButton:pressed to false.
    wait 0.
    set FrontFlapSlider:value to 0.
    set RearFlapSlider:value to 90.
    set AuthSlider:value to 25.
    sas on.
    wait 0.2.
    if SASControlButton:pressed {
        set sasmode to "RETROGRADE".
    }
    RCS on.
    when alt:radar - 22.8 < 45 or ship:verticalspeed > -45 then {
        set FrontFlapSlider:value to 80.
        set AuthSlider:value to 0.
    }
    when SASControlButton:pressed and ship:groundspeed < 2 or SASControlButton:pressed and alt:radar - 22.8 < 25 or SASControlButton:pressed and ship:verticalspeed > -14 then {
        set sasmode to "RADIALOUT".
    }
    when alt:radar - 22.8 < 45 then {
        Gear on.
    }
    when alt:radar - 22.8 < 3 then {
        toggle ag10.
    }
    when ship:status = "Landed" or ship:status = "Splashed" then {
        toggle ag10.
        wait 6.
        set RearFlapSlider:value to 0.
        rcs off.
        if SASControlButton:pressed {
            set sasmode to "STABILITY".
        }
        set LandingAssistButton:pressed to false.
        toggle ag10.
        wait 5.
        toggle ag10.
        set FrontFlapSlider:value to FrontAngleDefault.
        set RearFlapSlider:value to RearAngleDefault.
        set AuthSlider:value to AuthLimitDefault.
        set SliderLinkButton:pressed to false.
        FlapControl(FrontFlapSlider:value, RearFlapSlider:value, AuthSlider:value).
        SLEngineControl(Engine1Button:pressed, Engine2Button:pressed, Engine3Button:pressed).
        
    }
    
}

//main code
when abort then {
    wait 0.2.
    abort off.
    if AbortReset {
        Reboot.
    }
    else if AbortEngineStart {
        set Engine1Button:pressed to 1.
        set Engine2Button:pressed to 1.
        set Engine3Button:pressed to 1.
        set RvacButton:pressed to 1.
        if not(ship:status = "Orbiting") and not(ship:status = "Escaping") {
            set ship:control:pilotmainthrottle to 1.
            sas on.
            rcs on.
        }
    }
    wait 0.2.
    preserve.
}
CreateGUI().
FlapControl(FrontFlapSlider:value, RearFlapSlider:value, AuthSlider:value).
SLEngineControl(Engine1Button:pressed, Engine2Button:pressed, Engine3Button:pressed).
wait until false.
