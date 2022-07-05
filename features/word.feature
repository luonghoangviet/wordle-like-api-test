Feature: Verify API Guess against a selected word (/word)

  Scenario: Guess a selected word with default size (check json response schemas)
    Given an openapi file /data/openapi/openapi.json
    When I make a GET request to "/word/ahihi" with parameters
      | guess |
      | aloha |
    Then the response status code should equal 200
    And the response status message should equal "OK"
    And the response json matches defined schema ListGuessResult

  Scenario: Guess a selected word with valid world
    When I make a GET request to "/word/hello" with parameters
      | guess |
      | aloha |
    Then the response status code should equal 200
    And the response status message should equal "OK"
    And the response contains a json body like
    """
    [
      {
        "slot": 0,
        "guess": "a",
        "result": "absent"
      },
      {
        "slot": 1,
        "guess": "l",
        "result": "present"
      },
      {
        "slot": 2,
        "guess": "o",
        "result": "present"
      },
      {
        "slot": 3,
        "guess": "h",
        "result": "present"
      },
      {
        "slot": 4,
        "guess": "a",
        "result": "absent"
      }
    ]
    """