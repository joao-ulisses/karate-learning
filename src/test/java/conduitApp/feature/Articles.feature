Feature: Articles

    Background: Define URL
        Given url apiUrl
        
    Scenario: Create a new article
        Given path 'articles'
        And request { "article": { "tagList": [], "title": "joaotitle", "description": "aaa", "body": "aaa" } }
        When method Post
        Then status 201
        # And match response.article.title == 'ada4'

    Scenario: Create and delete article
        Given path 'articles'
        And request { "article": { "tagList": [], "title": "Delete this34", "description": "aaa", "body": "aaa" } }
        When method Post
        Then status 201
        * def articleID = response.article.slug

        Given path 'articles',articleID
        When method Delete
        Then status 204
