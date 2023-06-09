# Olio Tech Test

## Task

Firstly, the list of articles is stored here, https://s3-eu-west-1.amazonaws.com/olio-staging-images/developer/test-articles-v4.json, and you'll need to pull this from the server on page load (as it may change).

It would be great if you could display the list of articles on the page. Lastly, we'd like to be able to 'like' an article, with the data persisted and updated with each new page load. The likes are global and not per user.

## Tech
- Ruby 3.2.2
- Rails 7.0.5
- Postgresql 1.1
- aws-sdk-s3
- Bootstrap
- RSpec
- VCR
- Rubocop

## Setup
First clone the repository. Once cloned, run `bundle` to install the Gems. Next set up the database:

`rails db:create db:schema:load`

This will set up the development and test databases.

Copy `.env.example` to `.env` and `.env.test`. Fill in the required information.

Instructions on how to get AWS credentials can be found here: https://aws.amazon.com/blogs/security/wheres-my-secret-access-key/

## Usage
In the console run `rails s` to boot your local server. You can then visit `localhost:3000` to use the system. From here you may view a list of articles. Click on an article to see more information. You can also like the article from this page. Likes are shown here and on the list page.

## Testing
The application was developed with Test Driven Development. To run the test suite (unit tests), use `rspec` in the console. The test files are located in the `spec` directory.

## Coding Techniques
The following coding techniques/patterns have been used in the development of this challenge:
- Dependency Injection
- Test Driven Development
- Memoization/caching
- SOLID design principles

## Choices and Assumptions
I made several choices and assumptions during the development process, many of which have been made due to time constraints. These include:
- How changeable is the data in the download file?
  - Potentially, quite changeable. Therefore I have chosen a small subset of data to save and display
- There is no user system and likes are global, therefore:
  - Likes are recorded directly against the article
  - No likes model means no additional database query and no N+1 worries
  - This could cause issues if a user and like per user feature is requested, but there are methods to deal with this.
- Can articles be unliked
  - No

## Future Improvements
1. More testing (Controller tests and Feature tests)
2. Large datasets could lead to performance issues. In this case, run the download job asynchronously to protect the system.
3. Flesh out article pages with more data (if stable)
4. Update to a more sophisticated UI/Design
5. More exception/error handling.
6. Job to remove out-of-date articles
