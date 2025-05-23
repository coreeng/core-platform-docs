Feature: Service Healthcheck
  Ensure the service is operational and responsive

  Scenario: Service healthcheck endpoint requests succeed
    Given that the service is running
    When I call the healthcheck endpoint
    Then an ok response is returned
