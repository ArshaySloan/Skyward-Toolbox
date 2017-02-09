//JavaScript to create converter tool at the bottom of the time off screen in Skyward.
//This is based on a the HoursPerDay variable!  Change it to reflect the hours worked per day
//02/18/2017  removed hard coded 7.5 in favor of a variable called HorusPerDay

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
    // (WORKING CODE)pageContentWrap.innerHTML = pageContentWrap.innerHTML + "<table width='768'><tbody><tr><td><fieldset><legend class='FormTitle'>Hours to Day Conversion Tool</legend><br><br><div id='CustomCode' class=EditLabel'> Hours  to Convert</div><select id=CCHours type='text' name=HoursToConvert <option></option><option value='0.00'>0.00 (0 Minutes)</option><option value='0.25'>0.25 (15 Minutes)</option><option value='0.5'>0.5 (30 Minutes)</option><option value='0.75'>0.75 (45 Minutes)</option><option value='1'>1 (1 Hour)</option><option value='1.25'>1.25 (1 Hour and 15 Minutes)</option><option value='1.5'>1.5 (1 Hour and 30 Minutes)</option><option value='1.75'>1.75 (1 Hour and 45 Minutes)</option><option value='2'>2 (2 Hours)</option><option value='2.25'>2.25 (2 Hours and 15 Minutes)</option><option value='2.5'>2.5 (2 Hours and 30 Minutes)</option><option value='2.75'>2.75 (2 Hours and 45 Minutes)</option><option value='3'>3 (3 Hours)</option><option value='3.25'>3.25 (3 Hours and 15 Minutes)</option><option value='3.5'>3.5 (3 Hours and 30 Minutes)</option><option value='3.75'>3.75 (3 Hours and 45 Minutes [Half Day])</option><option value='4'>4 (4 Hours)</option><option value='4.25'>4.25 (4 Hours and 15 Minutes)</option><option value='4.5'>4.5 (4 Hours and 30 Minutes)</option><option value='4.75'>4.75 (4 hours and 45 Minutes)</option><option value='5'>5 (5 Hours)</option><option value='5.25'>5.25 (5 Hours and 15 Minutes)</option><option value='5.5'>5.5 (5 Hours and 30 Minutes)</option><option value='5.75'>5.75 (5 Hours and 45 Minutes)</option><option value='6'>6 (6 Hours)</option><option value='6.25'>6.25 (6 Hours and 15 Minutes)</option><option value='6.5'>6.5 (6 Hours and 30 Minutes)</option><option value='6.75'>6.75 (6 Hours and 45 Minutes)</option><option value='7'>7 (7 Hours)</option><option value='7.25'>7.25 (7 Hours and 15 Minutes)</option><option value='" + HoursPerDay + "'>" + HoursPerDay + "(7 Hours and 30 Minutes [Whole Day])</option></select><br><br><div id='CustomCode' class=EditLabel'> Converted Day(s)  </div><input id='CCDays' type='text' name=ConvertedDay readonly='readonly' value=0.0000><br><br><input type='checkbox' id='Neg_Entry' name='Neg_Entry' value='Neg_Entry'> Time off Reversal?<br><br></fieldset></td></tr></tbody></table>"
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