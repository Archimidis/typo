Feature: Merge Articles
    As a blog administrator
    I want to merge two articles
    So that I can gather information about the same topic in one article

    Background:
        Given the blog is set up with an admin
        And there is a publisher
        And there is an article with title "Article 1"
        And there is an article with title "Article 2"

    Scenario: An admin is able to merge articles
        Given I am logged into the admin panel as an admin
        And I visit the edit content page of article with title "Article 1"
        Then I should see the merge article function

    Scenario: A non-admin cannot merge two articles
        Given I am logged into the admin panel as a publisher
        And I visit the edit content page of article with title "Article 1"
        Then I should not see the merge article function

    Scenario:
        Given I am logged into the admin panel as an admin
        And I visit the edit content page of article with title "Article 1"
        When I merge article with title "Article 2"
        Then I should see "Articles were merged"
        And a merged article should be created
        And the merged article should contain the text of both previous articles
        And the merged article should have one author
        And the title of the new article should be the title from either one of the merged articles
        #And the merged article should have the comments of both previous articles
