require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

Given /^the blog is set up with an admin$/ do
  Blog.default.update_attributes!({blog_name: 'Testing Blog',
                                   base_url: 'http://localhost:3000'});
  Blog.default.save!
  Factory.create(:user,
                 login: 'admin',
                 password: 'aaaaaaaa',
                 email: 'joe@snow.com',
                 profile_id: 1,
                 name: 'admin',
                 state: 'active',
                 profile: Factory.build(:profile_admin, label: Profile::ADMIN))
end

Given /^I am logged into the admin panel as an admin$/ do
  visit '/accounts/login'
  fill_in 'user_login', :with => 'admin'
  fill_in 'user_password', :with => 'aaaaaaaa'
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
end

Given /^there is a publisher$/ do
  profile = Factory.build(:profile_publisher)
  user = Factory.create(:user,
                        login: 'publisher',
                        password: 'aaaaaaaa',
                        email: 'publisher@snow.com',
                        profile_id: 2,
                        name: 'publisher',
                        state: 'active',
                        profile: profile)
  user.should_not be_nil
end

Given /^I am logged into the admin panel as a publisher$/ do
  visit '/accounts/login'
  fill_in 'user_login', :with => 'publisher'
  fill_in 'user_password', :with => 'aaaaaaaa'
  click_button 'Login'
  if page.respond_to? :should
    page.should have_content('Login successful')
  else
    assert page.has_content?('Login successful')
  end
end

Given /^there is an article with title "(.*?)"$/ do |title|
  user = User.find_by_login('admin')
  user.should_not be_nil

  Factory.create(:article, author: user.login, title: title)
  article =  Article.find_by_title(title)
  article.should_not be_nil
  article.user.email.should eq(user.email)
end

Given /^I visit the edit content page of article with title "(.*?)"$/ do |title|
  @article_1 = Article.find_by_title(title)
  visit "/admin/content/edit/#{@article_1.id}"
end

Then /^I should( not)? see the merge article function$/ do |negate|
  expectation = negate ? :should_not : :should

  begin
    merge_btn = find_button('Merge')
    article_id = find_field('merge_with')
  rescue Capybara::ElementNotFound
  end

  merge_btn.send(expectation, be_present)
  article_id.send(expectation, be_present)
  if negate.nil?
    expect(page).to have_content 'Merge Articles'
  else
    expect(page).to_not have_content 'Merge Articles'
  end
end

When /^I merge article with title "(.*?)"$/ do |title|
  @article_2 = Article.where(title: title).where('id <> ?', @article_1.id).first
  @article_2.should_not be_nil
  fill_in('Article ID', with: @article_2.id)
  click_on('Merge')
end

Then /^a merged article should be created$/ do
  articles = find_merged_article
  articles.should be_present
end

Then /^the merged article should contain the text of both previous articles$/ do
  final_article = find_merged_article
  final_article.should_not be_nil

  expect(final_article.body).to include(@article_1.body, @article_2.body)
end

Then /^the merged article should have one author$/ do
  final_article = find_merged_article
  final_article.should_not be_nil
  expected = /#{@article_1.author}|#{@article_2.author}/

  expect(final_article.author).to match(expected)
end

Then /^the title of the new article should be the title from either one of the merged articles$/ do
  final_article = find_merged_article
  final_article.should_not be_nil
  expected = /#{@article_1.title}|#{@article_2.title}/

  expect(final_article.title).to match(expected)
end

def find_merged_article
  Article.where(title: @article_1.title, author: @article_1.author).first
end
