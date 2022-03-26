window.addEventListener("message", function(event) {
    var incomData = event.data;
    switch (incomData.process) {
        case 'show':
            $('body').css({'display': `block`})
            var speedsInt = incomData.speedLevel.toFixed()
            $('#gear span').text(incomData.gearLevel)
            $('#speeds span').text(speedsInt)
            $('.progress').css({'width': incomData.rpmLevel + `%`})
            if (incomData.fuelLevel > 80.0) {
                $('.pump svg').css({'fill': `#209d05`})
                $('.pump svg').css({'filter': `drop-shadow(3px 5px 2px #209d059c)`})
            } else if (incomData.fuelLevel > 60.0) {
                $('.pump svg').css({'fill': `#86e62c`})
                $('.pump svg').css({'filter': `drop-shadow(3px 5px 2px #86e62c9c)`})
            } else if (incomData.fuelLevel > 40.0) {
                $('.pump svg').css({'fill': `#ebff0a`})
                $('.pump svg').css({'filter': `drop-shadow(3px 5px 2px #ebff0a9c)`})
            } else if (incomData.fuelLevel > 20.0) {
                $('.pump svg').css({'fill': `#f3ce03`})
                $('.pump svg').css({'filter': `drop-shadow(3px 5px 2px #f3ce039c)`})
            } else if (incomData.fuelLevel > 0.0) {
                $('.pump svg').css({'fill': `#fe0a0a`})
                $('.pump svg').css({'filter': `drop-shadow(3px 5px 2px #fe0a0a9c)`})
            }
            if (incomData.engineLevel > 800.0) {
                $('.engineHp svg').css({'fill': `#209d05`})
                $('.engineHp svg').css({'filter': `drop-shadow(3px 5px 2px #209d059c)`})
            } else if (incomData.engineLevel > 600.0) {
                $('.engineHp svg').css({'fill': `#86e62c`})
                $('.engineHp svg').css({'filter': `drop-shadow(3px 5px 2px #86e62c9c)`})
            } else if (incomData.engineLevel > 400.0) {
                $('.engineHp svg').css({'fill': `#ebff0a`})
                $('.engineHp svg').css({'filter': `drop-shadow(3px 5px 2px #ebff0a9c)`})
            } else if (incomData.engineLevel > 200.0) {
                $('.engineHp svg').css({'fill': `#f3ce03`})
                $('.engineHp svg').css({'filter': `drop-shadow(3px 5px 2px #f3ce039c)`})
            } else if (incomData.engineLevel > 0.0) {
                $('.engineHp svg').css({'fill': `#fe0a0a`})
                $('.engineHp svg').css({'filter': `drop-shadow(3px 5px 2px #fe0a0a9c)`})
            }
            if (incomData.handbrakeLevel) {
                $('.handbrake svg').css({'fill': `#eb2323`})
                $('.handbrake svg').css({'filter': `drop-shadow(3px 5px 2px #eb232396)`})
            } else {
                $('.handbrake svg').css({'fill': `#e0e0e0`})
                $('.handbrake svg').css({'filter': `drop-shadow(3px 5px 2px #dbdbdb96)`})
            }
            if (incomData.lightsLevel == 1) {
                $('.headlights svg').css({'fill': `#209d05`})
                $('.headlights svg').css({'filter': `drop-shadow(3px 5px 2px #209d059c)`})
            } else if (incomData.lightsLevel == 2) {
                $('.headlights svg').css({'fill': `#0fa4e9`})
                $('.headlights svg').css({'filter': `drop-shadow(3px 5px 2px #0fa4e99c)`})
            } else if (incomData.lightsLevel == 0) {
                $('.headlights svg').css({'fill': `#e0e0e0`})
                $('.headlights svg').css({'filter': `drop-shadow(3px 5px 2px #e0e0e09c)`})
            }
            if (incomData.seatbeltLevel) {
                $('.seatbelt svg').css({'fill': `#209d05`})
                $('.seatbelt svg').css({'filter': `drop-shadow(3px 5px 2px #209d059c)`})
            } else {
                $('.seatbelt svg').css({'fill': `#e0e0e0`})
                $('.seatbelt svg').css({'filter': `drop-shadow(3px 5px 2px #e0e0e09c)`})
            }
        break
        case 'hide':
            $('body').css({'display': `none`})
        break
    }
});