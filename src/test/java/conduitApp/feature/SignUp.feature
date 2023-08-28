Feature: Sign Up new user

    Background: Preconditions
        * def dataGenerator = Java.type('conduitApp.helpers.DataGenerator')
        Given url apiUrl
    
@debug
    Scenario: New User Sign Up
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()

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