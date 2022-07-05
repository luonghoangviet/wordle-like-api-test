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

  Scenario Outline: Guess selected word that contain non-letters
    When I make a GET request to "/word/hello" with parameters
      | guess   |
      | <guess> |
    Then the response status code should equal 400
    And the response status message should equal "Bad Request"
    And the response contains text
    """
    Guess must only contain letters
    """

    Examples:
      | guess |
      | Be ha |
      | $in5b |
      | 12345 |

  Scenario: Guess a selected world when missing required field
    When I make a GET request to "/word/hello" with parameters
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