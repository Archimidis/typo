Given /^there is the category "(.*?)"$/ do |name|
  unless Category.find_by_name(name)
    Factory.create(:category, name: name)
  end
end

Then /^I should be able to create new categories$/ do
  expect(page).to have_selector('input', id: 'category_name')
  expect(page).to have_selector('input', value: 'Save')
end

Then /^I should see the category "(.*?)"$/ do |arg1|
  expect(page).to have_content("General")
end

Then /^I should be able to edit existing categories$/ do
  within('tr#category_1') do
    expect(page).to have_selector('td a', value: 'Edit')
  end
end
