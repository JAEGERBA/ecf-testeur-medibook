*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/POM/register.resource

Suite Setup       Open MediBook Browser
Suite Teardown    Close MediBook Browser

Test Setup        Reset Browser State
Test Teardown     Reset Browser State

*** Test Cases ***
Inscription réussie
    Open Register Page
    ${email}=    Generate Unique Email
    Log To Console    ${email}
    Register Patient    Test    Automatise    ${email}    Password123!
    Expect Registration Success Or Show Error    Test

Inscription échouée - Email déjà utilisé
    Open Register Page
    Register Patient    Test    Automatise    ${PATIENT_EMAIL}    Password123!
    Wait Alert Error Contains    Un compte existe déjà avec cet email