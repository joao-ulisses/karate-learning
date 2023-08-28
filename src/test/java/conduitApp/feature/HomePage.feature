@debug
Feature: Tests for the home page

Background: Define URL
    Given url apiUrl
    
    Scenario: Get all tags
        Given path 'tags'
        When method Get
        Then status 200
        And match response.tags == "#array"
        And match each response.tags == "#string"
        
    Scenario: Get 10 articles from the 
        Given params { limit: 10, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        And match response.articlesCount != 197
        And match response == 
        """
            {
                "articles": "#array",
                "articlesCount": "#number"
            }
        """
        And match each response.articles[*].favoritesCount == "#present"
        And match each response..favoritesCount == "#number"
        And match each response..bio == "#present"
        And match each response..bio == "##string"
        And match each response..following == false
        And match each response..following == "#boolean"
