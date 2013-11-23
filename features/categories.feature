Feature: Article Categories
    As a blog administrator
    I want to have categories
    So that I can categorize the articles

    Background:
        Given the blog is set up with an admin
        And there is the category "General"

    Scenario:
        Given I am logged into the admin panel as an admin
        When I go to the category page
        Then I should be able to create new categories
        And I should be able to create new categories
        And I should see the category "General"
        And I should be able to edit existing categories
