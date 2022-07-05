Feature: Verify API Guess against a random word (/random)

  Scenario: Guess a random word with default size (check json response schemas)
    Given an openapi file /data/openapi/openapi.json
    When I make a GET request to "/random" with parameters
      | guess |
      | match |
    Then the response status code should equal 200
    And the response status message should equal "OK"
    And the response json matches defined schema ListGuessResult

  Scenario: Guess a random word with valid size and seed
    When I make a GET request to "/random" with parameters
      | guess | seed  | size |
      | out   | 12345 | 3    |
    Then the response status code should equal 200
    And the response status message should equal "OK"
    And the response contains a json body like
    """
    [
      {
        "slot": 0,
        "guess": "o",
        "result": "correct"
      },
      {
        "slot": 1,
        "guess": "u",
        "result": "correct"
      },
      {
        "slot": 2,
        "guess": "t",
        "result": "correct"
      }
    ]
    """

    Scenario: Guess a random word with valid size and seed
    When I make a GET request to "/random" with parameters
      | guess | seed  | size |
      | out   | 12345 | 3    |
    Then the response status code should equal 200
    And the response status message should equal "OK"