@debug
Feature: Hooks

    Background: hooks
        # * def result = callonce read('classpath:conduitApp/helpers/Dummy.feature')
        * def username = ''

        * configure afterScenario = function(){ karate.call('classpath:conduitApp/helpers/Dummy.feature') }
        * configure afterFeature = 
        """
            function() {
                karate.log('After Feature Text');
            }
        """

    Scenario: First Scenario
        * print username
        * print 'This is the first scenario'

    Scenario: Second Scenario
        * print username
        * print 'This is the second scenario'