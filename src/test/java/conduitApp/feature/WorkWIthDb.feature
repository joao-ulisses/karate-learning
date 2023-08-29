@ignore
Feature: work with DB

    Background: connect to db
        * def dbHandler = Java.type('conduitApp.helpers.DbHandler')

    Scenario:  Seed database with a new Job
        * eval dbHandle.addNewJobWithName("Qa2")
    
    Scenario: Get level for job
        * def level = dbHandler.getMinAndMaxLevelsForJob("Qa2")
        * print level.minLvl
        * print level.maxLvl
        And match level.minLvl = '80'
        And match level.maxLvl = '120'