*** Settings ***
Library    SeleniumLibrary
Library    String

*** Variables ***
${BASE_URL}     http://localhost:3000
${BROWSER}      chrome
${HEADLESS}     true
${TIMEOUT}      10s
${NO_RESULTS_MSG}      Aucun praticien trouvé avec ces critères.
${APPT_PAGE_TITLE}     Mes rendez-vous
${APPT_CONFIRMED_TXT}  Rendez-vous confirmé

${PATIENT_EMAIL}      jean.dupont@email.com
${PATIENT_PASSWORD}   Password123!

*** Keywords ***
Open MediBook Browser
    ${options}=    Create Chrome Options
    Open Browser    about:blank    ${BROWSER}    options=${options}
    Set Selenium Timeout    ${TIMEOUT}
    Set Window Size    1400    900
    Go To Path    /
    Reset Browser State

Close MediBook Browser
    Close All Browsers

Create Chrome Options
    ${chrome_options}=    Evaluate    __import__("selenium.webdriver").webdriver.ChromeOptions()    selenium.webdriver
    Run Keyword If    '${HEADLESS}'=='true'    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    [Return]    ${chrome_options}

Go To Path
    [Arguments]    ${path}
    Go To    ${BASE_URL}${path}
    Wait Until Page Contains Element    xpath=//body    ${TIMEOUT}

Generate Unique Email
    ${rand}=    Generate Random String    8    [LETTERS][NUMBERS]
    ${email}=   Set Variable    test.auto+${rand}@email.com
    [Return]    ${email}

Click Button Contains Text
    [Arguments]    ${text}
    ${btn}=    Set Variable    xpath=//button[contains(normalize-space(.), "${text}")]

    Wait Until Element Is Visible    ${btn}    ${TIMEOUT}
    Scroll Element Into View         ${btn}
    Wait Until Keyword Succeeds      10x    300ms    Element Should Be Enabled    ${btn}

    ${status}    ${msg}=    Run Keyword And Ignore Error    Click Element    ${btn}
    Run Keyword If    '${status}'=='FAIL'    Click Element Via JS    ${btn}

Click Element Via JS
    [Arguments]    ${locator}
    Execute JavaScript    document.evaluate(arguments[0], document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();    ${locator}

Wait Alert Error Contains
    [Arguments]    ${text}
    Wait Until Page Contains Element    xpath=//div[@role="alert" and contains(@class,"alert-error")]    ${TIMEOUT}
    Page Should Contain    ${text}


# obligé d'ajouter ça car sinon je suis tt le temps connecté et ça empeche de tester l'inscription
Reset Browser State
    Delete All Cookies
    Execute Javascript    window.localStorage.clear();
    Execute Javascript    window.sessionStorage.clear();
    Reload Page