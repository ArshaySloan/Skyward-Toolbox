// JavaScript used to restrict items on the page based on security level, and select the second Check Request Group, and select the first fiscal year.
// This example is used to remove 1099 check boxes for end users who's security is 4 or below.

//Created by Arshay "Shay" Sloan @ GCISD

//Conditional statement based on users securiy (not lookup security)
if (getUserSecLevel() <= 4) {
//Because the check request detail line has multipul lines, this creates a four loop to hide all of them.
    for (var i = 1; i < 300; i++) {
        hideFields('c1099' + i + ',c1099' + i + 'label');
    }
}
//Normally GCISD sets up 2 po groups one for PO and the second one for check request this selects the second option by default.
setTimeout(function() {
    sPOGroup.value = sPOGroup.options[0].value;
    sPOGroup.value = sPOGroup.options[1].value;
}, 10);
setTimeout(function() {
    fiscalYear.value = fiscalYear.options[0].value;
}, 1);
