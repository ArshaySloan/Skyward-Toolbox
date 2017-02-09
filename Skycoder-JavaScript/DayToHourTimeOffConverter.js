//JavaScript to create converter tool at the bottom of the time off screen in Skyward.
//This is based on a the HoursPerDay variable!  Change it to reflect the hours worked per day
//02/08/2017  removed hard coded 7.5 in favor of a variable called HorusPerDay
//02/09/2017 Beautifying and removing dead commented code used for testing

//Negative balance button added on request to have the ability to refund time.

//Created by Arshay "Shay" Sloan @ GCISD

// If time off is in hours and not days ignore everything

var HoursPerDay = 7.5
var NumberOfOptions = HoursPerDay * 4
var part1 = "<table width='768'><tbody><tr><td><fieldset><legend class='FormTitle'>Hours to Day Conversion Tool</legend><br><br><div id='CustomCode' class=EditLabel'> Hours  to Convert</div><select id=CCHours type='text' name=HoursToConvert <option></option>"
var options = "<option value='0.0000'>0.00 (0 Minutes)</option>"
var part2 = "</select><br><br><div id='CustomCode' class=EditLabel'> Converted Day(s)  </div><input id='CCDays' type='text' name=ConvertedDay readonly='readonly' value=0.0000><br><br><input type='checkbox' id='Neg_Entry' name='Neg_Entry' value='Neg_Entry'> Time off Reversal?<br><br></fieldset></td></tr></tbody></table>"
if ((trRequestHours.style.display == 'none')) {
    // Used to disable the day field from being edited.
    tDaysDec.disabled = true;

    //For loop to build options variable for selection tool.
    for (i = 1; i <= NumberOfOptions; i++) {
        if (((HoursPerDay / NumberOfOptions) * i).toFixed(2) == HoursPerDay) {
            options = options + "<option value='" + ((HoursPerDay / NumberOfOptions) * i).toFixed(2) + "'>" + ((HoursPerDay / NumberOfOptions) * i).toFixed(2) + " Hours (WHOLE DAY)</option>";
        } else if (((HoursPerDay / NumberOfOptions) * i).toFixed(2) == (HoursPerDay / 2)) {
            options = options + "<option value='" + ((HoursPerDay / NumberOfOptions) * i).toFixed(2) + "'>" + ((HoursPerDay / NumberOfOptions) * i).toFixed(2) + " Hours (HALF DAY)</option>";
        } else {
            options = options + "<option value='" + ((HoursPerDay / NumberOfOptions) * i).toFixed(2) + "'>" + ((HoursPerDay / NumberOfOptions) * i).toFixed(2) + " Hours</option>";
        }
    }
    // Code to Insert the custom converter to the bottom of the time off date.
    pageContentWrap.innerHTML = pageContentWrap.innerHTML + part1 + options + part2
    //Information read only box for custom converter
    document.getElementById("CCDays").disabled = true;

    document.getElementById("CCHours").onchange = function() {
        convertHoursToDays()
    };
    document.getElementById("Neg_Entry").onchange = function() {
        Negative_Balance()
    };

    function convertHoursToDays() {
        CCDays.value = parseFloat(parseFloat(CCHours.value) / HoursPerDay).toFixed(4);
        tDaysDec.value = CCDays.value;
        if (tDaysDec.value > .4999) {
            //Warning message for employees to use AESOP if a sub is needed.
            alert('Stop!\n\nYou are entering time off for a 1/2 day or more.  If a substitute was requested through AESOP, please discontinue this entry.  If no substitute was needed or requested, you may continue with your entry for time off in Skyward.\n\nEntering time off in AESOP AND Skyward will create duplicate requests and deduct your request twice from your available leave.');
        }
        Negative_Balance();
    }
    //If requesting time back changes day to negative.
    function Negative_Balance() {
        if (Neg_Entry.checked == true) {
            tDaysDec.value = (tDaysDec.value * -1);
        } else {
            tDaysDec.value = CCDays.value;
        }
    }
}
