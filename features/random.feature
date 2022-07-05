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

    Scenario Outline: Guess random word that contain non-letters
    When I make a GET request to "/random" with parameters
      | guess   | size   |
      | <guess> | <size> |
    Then the response status code should equal 400
    And the response status message should equal "Bad Request"
    And the response contains text
    """
    Guess must only contain letters
    """

    Examples:
      | guess            | size |
      | Behave framework | 16   |
      | $in              | 3    |
      | 123456           | 6    |

  Scenario: Guess a random word too short
    When I make a GET request to "/random" with parameters
      | guess |
      | abc   |
    Then the response status code should equal 400
    And the response status message should equal "Bad Request"
    And the response contains text
    """
    Guess must be the same length as the word
    """

  Scenario: Guess a random word too long
    When I make a GET request to "/random" with parameters
      | guess                   | size |
      | Behaveframeworkahihiuhi | 23   |
    Then the response status code should equal 500
    And the response status message should equal "Internal Server Error"


    Scenario: Guess a random word when size is not match with guess
    When I make a GET request to "/daily" with parameters
      | guess  | size |
      | tester | 7    |
    Then the response status code should equal 400
    And the response status message should equal "Bad Request"
    And the response contains text
    """
    Guess must be the same length as the word
    """

 Scenario: Guess a daily world when missing required field
    When I make a GET request to "/random" with parameters
      | size |
      | 6    |
    Then the response status code should equal 422
    And the response status message should equal "Unprocessable Entity"
    And the response contains a json body like
    """
    {
      "detail": [
        {
          "loc": [
            "query",
            "guess"
          ],
          "msg": "field required",
          "type": "value_error.missing"
        }
      ]
    }
    """

  Scenario: Guess a random world when data type of size is wrong
    When I make a GET request to "/random" with parameters
      | guess | size  |
      | match | ahihi |
    Then the response status code should equal 422
    And the response status message should equal "Unprocessable Entity"
    And the response contains a json body like
    """
    {
      "detail": [
        {
          "loc": [
            "query",
            "size"
          ],
          "msg": "value is not a valid integer",
          "type": "type_error.integer"
        }
      ]
    }
    """