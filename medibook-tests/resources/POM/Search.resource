*** Settings ***
Resource    ../common.resource

*** Keywords ***
Open Search Page
    Go To Path    /search
    Wait Until Page Contains Element    id:specialty    ${TIMEOUT}
    Wait Until Page Contains Element    id:city         ${TIMEOUT}

Search Practitioner
    [Arguments]    ${spé}    ${ville}
    ${ok}=    Run Keyword And Return Status    Select From List By Label    id:specialty    ${spé}
    IF    not ${ok}
        ${opts}=    Get List Items    id:specialty
        Log    Specialty '${spé}' not found. Available: ${opts}    console=True
        Select From List By Index    id:specialty    0
    END
    Input Text    id:city    ${ville}
    Click Button Contains Text    Rechercher

Expect Results
    Wait Until Page Contains Element    css:a.practitioner-card    ${TIMEOUT}

Open First Practitioner
    Wait Until Page Contains Element    css:a.practitioner-card    ${TIMEOUT}
    Click Element    css:a.practitioner-card

Expect No Results Message
    Wait Until Page Contains    ${NO_RESULTS_MSG}    ${TIMEOUT}