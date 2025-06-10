Feature: Health Check Endpoints

  Scenario: Verify /livez endpoint
    When User sends a GET request to "/livez"
    Then The response status code should be 200
    And The response body should be "OK"

  Scenario: Verify /readyz endpoint
    When User sends a GET request to "/readyz"
    Then The response status code should be 200
    And The response body should be "OK"
