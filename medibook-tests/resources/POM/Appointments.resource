*** Settings ***
Resource    ../common.resource

*** Keywords ***
Expect Appointment Page
    [Documentation]    Vérifie la page "Mes rendez-vous"
    Wait Until Page Contains    ${APPT_PAGE_TITLE}    ${TIMEOUT}

Expect Appointment Listed
    Wait Until Page Contains Element    css:li.appointment-card.card    ${TIMEOUT}