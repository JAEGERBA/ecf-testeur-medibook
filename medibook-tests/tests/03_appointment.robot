*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/POM/login.resource
Resource    ../resources/POM/search.resource
Resource    ../resources/POM/PractitionerDetail.resource
Resource    ../resources/POM/appointments.resource

Suite Setup       Open MediBook Browser
Suite Teardown    Close MediBook Browser

*** Test Cases ***
Réservation d'un créneau
    Open Login Page
    Login As Patient    ${PATIENT_EMAIL}    ${PATIENT_PASSWORD}
    Expect Login Success Or Show Error

    Open Search Page
    Search Practitioner    Médecin généraliste    Paris
    Expect Results
    Open First Practitioner

    Select First Available Date
    Select First Slot
    Confirm Appointment

    Wait Until Page Contains    ${APPT_CONFIRMED_TXT}    ${TIMEOUT}
    Expect Appointment Page
    Expect Appointment Listed