Feature: Virtual Cash Drawer tests via WireMock

  Background:
    * url cashDrawerBaseUrl

  Scenario: Open drawer successfully
    Given path '/drawer/open'
    When method POST
    Then status 200
    And match response == { result: 'OK', message: 'Drawer opened successfully' }

  Scenario: Verify drawer is open
    Given path '/drawer/status'
    When method GET
    Then status 200
    And match response.status == 'open'

  Scenario: Close drawer
    Given path '/drawer/close'
    When method POST
    Then status 200
    And match response.message == 'Drawer closed successfully'

  Scenario: Verify drawer is closed
    Given path '/drawer/status'
    When method GET
    Then status 200
    And match response.status == 'closed'

  Scenario: Simulate failure
    Given path '/drawer/open'
    And param fail = true
    When method POST
    Then status 500
    And match response.error contains 'Drawer jammed'

  Scenario: Simulate delayed response
    Given path '/drawer/open'
    And param mode = 'slow'
    When method POST
    Then status 200
    And match response.message contains 'delay'

  Scenario: Reset drawer state
    Given path '/drawer/reset'
    When method POST
    Then status 200
    And match response.message == 'Scenario reset to initial state'
