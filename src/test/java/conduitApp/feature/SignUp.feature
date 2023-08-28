@ignore
Feature: Sign Up new user

    Background: Preconditions
        Given url apiUrl

    Scenario: New User Sign Up
        Given def userData = {"email": "testnao234@test.testnao","username": "testnao234"}

        Given path 'users'
        And request
        """
            {
                "user": {
                    "email": #(userData.email),
                    "password": "testnao2",
                    "username": #(userData.username)
                }
            }
        """
        When method Post
        Then status 201