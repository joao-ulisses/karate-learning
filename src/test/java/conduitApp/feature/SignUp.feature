@debug
Feature: Sign Up new user

    Background: Preconditions
        * def dataGenerator = Java.type('conduitApp.helpers.DataGenerator')
        * def timeValidator = read('classpath:conduitApp/helpers/timeValidator.js')
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()
        Given url apiUrl
    
    Scenario: New User Sign Up
        Given path 'users'
        And request
        """
            {
                "user": {
                    "email": #(randomEmail),
                    "password": "testnao2",
                    "username": #(randomUsername)
                }
            }
        """
        When method Post
        Then status 201
        And match response ==
        """
            {
               "user": {
                    "email": "#string",
                    "username": "#string",
                    "bio": null,
                    "image": "#string",
                    "token": "#string"
                }
            }
        """

    Scenario Outline: Validate Sign Up error messages
        Given path 'users'
        And request
        """
            {
                "user": {
                    "email": "<email>",
                    "password": "<password>",
                    "username": "<username>"
                }
            }
        """
        When method Post
        Then status 422
        And match response == <errorResponse>

        Examples: 
            | email                   | password | username          | errorResponse                                                                         |
            | #(randomEmail)          | testnao2 | testmailoi        | {"errors":{"username":["has already been taken"]}}                                    |
            | karatetestjao@test.test | testnao2 | #(randomUsername) | {"errors":{"email":["has already been taken"]}}                                       |
            | karatetestjao@test.test | testnao2 | testmailoi        | {"errors":{"email":["has already been taken"],"username": ["has already been taken"]}}|
