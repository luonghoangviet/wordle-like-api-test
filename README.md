BDD-style Rest API testing for [Wordle like api](https://github.com/k2bd/wordle-api)

It uses python's [requests](<https://pypi.python.org/pypi/requests/>)
for performing HTTP requests, [nose](<https://pypi.python.org/pypi/nose/1.3.7>) 
for most assertions, [behave] <https://pypi.python.org/pypi/behave/1.2.5>`
for BDD style of tests and [allure](https://docs.qameta.io/allure/) for a beautiful report.

Installation
------------
Run

  pip install -r requirements.txt # install required dependencies


Running
-------

    # to execute all feature files (all tests)
    behave
    
    # to execture specific feature
    behave features/word.feature

    # run features with specific tags
    behave --tags=without_login --tags=slow

    # generate report
    behave -f allure_behave.formatter:AllureFormatter -o %allure_result_folder% ./features
    allure serve %allure_result_folder%


Project Structure
-----------------

Feature files are intended to locate in `/features` folder

Corresponding steps are located in `/features/steps`

Overall project structure is as follows:

::

    +-- common // store project common thing (urls, global variables, etc.)    
    +-- config // store project config (urls, global variables, etc.)    
    +-- data // test data    
    +-- features/
        +-- environment.py // context setup steps (e.g. load from config)
        +-- *.feature // feature files (name of the API)
        +-- steps/ 
            +-- __init__.py // used to import predefined steps 
            +-- openapi_steps.py // response structures described in openapi
            +-- *.py // steps related to corresponding feature (e.g. "login.py" contains steps that are related to "login.feature")
    +-- util //some useful function

Project Structure
-----------------
References:
[1][Guru99](https://www.guru99.com/bdd-testing-rest-api-behave.html)
[2][Behave-Restful](https://github.com/behave-restful/behave-restful
)(3)[Behave-rest](https://github.com/stanfy/behave-rest)
