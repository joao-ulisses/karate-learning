Feature: Dummy

    Scenario: Dummy
        * def dataGenerator = Java.type('conduitApp.helpers.DataGenerator')
        * def username = dataGenerator.getRandomUsername()
        * print username