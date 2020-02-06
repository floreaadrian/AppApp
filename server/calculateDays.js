const createListToSend = (startTime, endTime, minutes, date, days) => {
    var weekday = new Array(7);
    weekday[0] = "Duminica";
    weekday[1] = "Luni";
    weekday[2] = "Marti";
    weekday[3] = "Miercuri";
    weekday[4] = "Joi";
    weekday[5] = "Vineri";
    weekday[6] = "Sambata";
    var day = weekday[new Date(date).getDay()];
    if (days.split(",").includes(day)) {
        return createHours(startTime, endTime, minutes);
    } else {
        return [];
    }
}

const createHours = (startTime, endTime, minutes) => {
    var listToReturn = [];
    const startHour = startTime.split(":")[0];
    const startMinute = startTime.split(":")[1];
    const endHour = endTime.split(":")[0];
    const endMinute = endTime.split(":")[1];
    const start = parseInt(startHour * 60) + parseInt(startMinute);
    const end = parseInt(endHour * 60) + parseInt(endMinute);
    for (i = start; i < end; i += minutes) {
        var newStartHour = parseInt(i / 60);
        if (newStartHour < 10) {
            newStartHour = "0" + newStartHour;
        }
        var newStartMinute = i % 60;
        if (newStartMinute < 10) {
            newStartMinute = "0" + newStartMinute;
        }
        var newEndHour = parseInt((i + minutes) / 60);
        if (newEndHour < 10) {
            newEndHour = "0" + newEndHour;
        }
        var newEndMinute = (i + minutes) % 60;
        if (newEndMinute < 10) {
            newEndMinute = "0" + newEndMinute;
        }
        listToReturn.push(newStartHour + ":" + newStartMinute + "-" + newEndHour + ":" + newEndMinute)
    }
    return listToReturn;
}

module.exports = createListToSend;