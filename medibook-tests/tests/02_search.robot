*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/POM/Search.resource

Suite Setup       Open MediBook Browser
Suite Teardown    Close MediBook Browser

*** Test Cases ***
Recherche par spécialité et ville
    Open Search Page
    Search Practitioner    Médecin généraliste    Paris
    Expect Results
    Page Should Contain Element    css:.practitioner-name
    Page Should Contain Element    css:.practitioner-specialty
    Page Should Contain Element    css:.practitioner-address

Recherche sans résultat
    Open Search Page
    Search Practitioner    Cardiologue    Village Inexistant    
    Expect No Results Message