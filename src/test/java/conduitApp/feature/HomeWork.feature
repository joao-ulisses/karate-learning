Feature: Home Work

    Background: Preconditions
        * url apiUrl 
        * def commentRequestBody = read('classpath:conduitApp/json/newCommentRequest.json')

    Scenario: Favorite articles
        * def timeValidator = read('classpath:conduitApp/helpers/timeValidator.js')
        # Step 1: Get atricles of the global feed
        Given params { limit: 1, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        # Step 2: Get the favorites count and slug ID for the first arice, save it to variables
        * def firstFavoritesCount = response.articles[0].favoritesCount
        * def slugId = response.articles[0].slug
        # Step 3: Make POST request to increse favorites count for the first article
        Given path 'articles/' + slugId + '/favorite'
        When method Post
        Then status 200
        # Step 4: Verify response schema
        And match response == 
        """
            {
                "article": {
                    "id": "#number",
                    "slug": "#string",
                    "title": "#string",
                    "description": "#string",
                    "body": "#string",
                    "createdAt": "#? timeValidator(_)",
                    "updatedAt": "#? timeValidator(_)",
                    "authorId": "#number",
                    "tagList": "#array",
                    "author": {
                        "username": "#string",
                        "bio": "##string",
                        "image": "#string",
                        "following": "#boolean"
                    },
                    "favoritedBy": "#array",
                    "favorited": "#boolean",
                    "favoritesCount": "#number"
                }
            }
        """
        # Step 5: Verify that favorites article incremented by 1
        * print "response: ", response.article.favoritesCount
        * print "previous: ", firstFavoritesCount
        And match response.article.favoritesCount == firstFavoritesCount

    Scenario: Comment articles
        * def timeValidator = read('classpath:conduitApp/helpers/timeValidator.js')
        # Step 1: Get atricles of the global feed
        Given params { limit: 1, offset: 0 }
        Given path 'articles'
        When method Get
        Then status 200
        # Step 2: Get the slug ID for the first arice, save it to variable
        * def slugId = response.articles[0].slug
        # Step 3: Make a GET call to 'comments' end-point to get all comments
        Given path 'articles/' + slugId + '/comments'
        When method Get
        Then status 200
        # Step 4: Verify response schema
        And match response == 
        """
            {
                "comments": "##array"
            }
        """
        # Step 5: Get the count of the comments array lentgh and save to variable
        * def commentsCount = response.comments.length
        # Step 6: Make a POST request to publish a new comment
        Given path 'articles/' + slugId + '/comments'
        And request commentRequestBody
        When method Post
        Then status 200
        * def commentId = response.comment.id
        # Step 7: Verify response schema that should contain posted comment text
        And match response == 
        """
            {
                "comment": {
                    "id": "#number",
                    "createdAt": "#? timeValidator(_)",
                    "updatedAt": "#? timeValidator(_)",
                    "body": "#string",
                    "author": {
                        "username": "#string",
                        "bio": "##string",
                        "image": "##string",
                        "following": "#boolean"
                    }
                }
            }
        """
        # Step 8: Get the list of all comments for this article one more time
        Given path 'articles/' + slugId + '/comments'
        When method Get
        Then status 200
        # Step 9: Verify number of comments increased by 1 (similar like we did with favorite counts)
        And response.commentsCount == commentsCount + 1
        # Step 10: Make a DELETE request to delete comment
        Given path 'articles/' + slugId + '/comments/' + commentId
        When method Delete
        Then status 200
        # Step 11: Get all comments again and verify number of comments decreased by 1
        Given path 'articles/' + slugId + '/comments'
        When method Get
        Then status 200
        And response.commentsCount == commentsCount - 1