*** Settings ***
Resource    ../common.resource

*** Keywords ***
Open Login Page
    Go To Path    /login
    Wait Until Page Contains    Connexion    ${TIMEOUT}

Login As Patient
    [Arguments]    ${email}    ${password}
    Input Text        id:email       ${email}
    Input Password    id:password    ${password}
    Click Button Contains Text    Se connecter

Expect Logged In
    [Documentation]    Vérifie l’état connecté via le header (.user-name)
    Wait Until Element Is Visible    css:.user-name    ${TIMEOUT}

Expect Login Success Or Show Error
    ${ok}=    Run Keyword And Return Status    Wait Until Element Is Visible    css:.user-name    5s
    IF    ${ok}
        RETURN
    END
    ${hasAlert}=    Run Keyword And Return Status    Page Should Contain Element    css:div[role="alert"]
    IF    ${hasAlert}
        ${msg}=    Get Text    css:div[role="alert"]
        Fail    Login failed: ${msg}
    ELSE
        Fail    Login failed: no user-name and no alert.
    END