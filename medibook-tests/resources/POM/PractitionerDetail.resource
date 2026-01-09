*** Settings ***
Resource    ../common.resource

*** Keywords ***
Select First Available Date
    Wait Until Page Contains Element    css:button.day-btn    ${TIMEOUT}
    Scroll Element Into View    css:button.day-btn
    Wait Until Page Contains Element    css:button.day-btn:not(.disabled):not([disabled])    ${TIMEOUT}
    Click Element    css:button.day-btn:not(.disabled):not([disabled])

Select First Slot
    Wait Until Page Contains Element    css:button.slot-btn    ${TIMEOUT}
    Scroll Element Into View    css:button.slot-btn
    Click Element    css:button.slot-btn

Confirm Appointment
    Click Button Contains Text    Confirmer le rendez-vous