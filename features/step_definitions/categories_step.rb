Given /^there is the category "(.*?)"$/ do |name|
  @category = Category.find_by_name(name)

  unless @category
    @category = Factory.create(:category, name: name)
  end
end

Then /^I should be able to create new categories$/ do
  expect(page).to have_selector('input', id: 'category_name')
  expect(page).to have_selector('input', value: 'Save')
end

When /^I visit the edit page of category "(.*?)"$/ do |arg1|
    visit "/admin/categories/edit/#{@category.id}"
end

Then /^I should see the category "(.*?)"$/ do |arg1|
  expect(page).to have_content("General")
  within('tr#category_1') do
    expect(page).to have_selector('td a', value: 'Edit')
  end
end

Then /^I should be able to edit existing categories$/ do
  name_value = page.find_field('category_name').value
  permalink_value = page.find_field('category_permalink').value
  description_value = page.find_field('category_description').value

  expect(name_value).to eq(@category.name)
  expect(permalink_value).to eq(@category.permalink)
  expect(description_value).to eq(@category.description.to_s)
end
