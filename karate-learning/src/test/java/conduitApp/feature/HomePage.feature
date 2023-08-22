Feature: Tests for the home page

Scenario: Get all tags
    Given url 'https://api.realworld.io/api/tags'
    When method Get
    Then status 200

Scenario: Get 10 articles from the 
    Given params { limit: 10, offset: 0 }
    Given url 'https://api.realworld.io/api/articles'
    When method Get
    Then status 200