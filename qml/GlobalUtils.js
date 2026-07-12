.pragma library

const toolTipBackgroundColor = ["#00000000" // 0 Transparent
                                , "#CC121212" // 1 Glass
                                , "#C4111111" // 2 Soft
                                , "#C41E1E1E" // 3 Soft
                                , "#F0202020" // 4 Default
                                , "#F0282828" // 5 Elevated
                                , "#FF303030"  // 6 Active
      ];

const toolTipBorderColor = ["#00000000", "#AA8A4B00", "orange", "#DDAA6600", "#EEBB7700", "#FFFF9800"];

const toolTipContentColor = ["#777777", "#A0A0A0", "#C0C0C0", "#D8D8D8", "#E8E8E8", "#FFFFFF"];

const toolTipContentHoverColor = ["#A0A0A0", "#CFCFCF", "#E0E0E0", "#FFFFFF", "#FFFFB74D", "#FFFF9800"];

const indicatorActiveLevels = {
    red: 0,
    yellow: 1,
    green: 2,
    orange: 3
};

function getInputActiveLevel(active, feedback) {
    if (active) {
        return indicatorActiveLevels.red;
    }
    return indicatorActiveLevels.green;
}
