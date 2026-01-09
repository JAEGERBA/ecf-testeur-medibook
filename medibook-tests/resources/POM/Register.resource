*** Settings ***
Resource    ../common.resource
Library     SeleniumLibrary

*** Variables ***
${TIMEOUT}    10s
${BASE_URL}   http://localhost:3000

*** Keywords ***
Open Register Page
    Go To Path    /register
    Wait Until Page Contains    Créer un compte    ${TIMEOUT}

Register Patient
    [Arguments]    ${first}    ${last}    ${email}    ${password}
    Input Text    id:firstName         ${first}
    Input Text    id:lastName          ${last}
    Input Text    id:email             ${email}
    Input Text    id:password          ${password}
    Input Text    id:confirmPassword   ${password}
    Click Element    css:input[name="acceptTerms"]
    Click Button Contains Text    Créer mon compte

Expect Registration Success Or Show Error
    [Arguments]    ${firstName}
    ${ok}=    Run Keyword And Return Status    Wait Until Location Is    ${BASE_URL}/    8s
    IF    ${ok}
        Validate Logged In User    ${firstName}
    ELSE
        Log Registration Error And Fail
    END

Validate Logged In User
    [Arguments]    ${firstName}
    Wait Until Element Is Visible    css:.user-name    ${TIMEOUT}
    Element Should Contain          css:.user-name    ${firstName}

Log Registration Error And Fail
    [Documentation]    Log l'erreur UI si présente puis échoue.
    ${hasAlert}=    Run Keyword And Return Status    Page Should Contain Element    css:div[role="alert"]

    IF    ${hasAlert}
        ${msg}=    Get Text    css:div[role="alert"]
        Log    Registration failed with alert: ${msg}    console=True
    ELSE
        Log    Registration failed but no alert found (possible API issue).    console=True
    END

    Capture Page Screenshot
    Fail    Registration did not redirect to home.