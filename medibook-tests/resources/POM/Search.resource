*** Settings ***
Resource    ../common.resource

*** Keywords ***
Open Search Page
    [Documentation]    Ouvre /search et attend un élément stable de la page.
    Go To Path    /search
    Wait Until Page Contains Element    id:specialty    ${TIMEOUT}
    Wait Until Page Contains Element    id:city         ${TIMEOUT}

Search Practitioner
    [Arguments]    ${specialty}    ${city}
    [Documentation]    Sélectionne une spécialité si elle existe, sinon fallback sur la 1ère option.
    ${ok}=    Run Keyword And Return Status    Select From List By Label    id:specialty    ${specialty}
    IF    not ${ok}
        ${opts}=    Get List Items    id:specialty
        Log    Specialty '${specialty}' not found. Available: ${opts}    console=True
        Select From List By Index    id:specialty    0
    END
    Input Text    id:city    ${city}
    Click Button Contains Text    Rechercher

Expect Results
    Wait Until Page Contains Element    css:a.practitioner-card    ${TIMEOUT}

Open First Practitioner
    [Documentation]    Ouvre le premier résultat
    Wait Until Page Contains Element    css:a.practitioner-card    ${TIMEOUT}
    Click Element    css:a.practitioner-card

Expect No Results Message
    Wait Until Page Contains    ${NO_RESULTS_MSG}    ${TIMEOUT}