#Roles
puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end

#Locations
puts 'Adding Locations'
@location = Location.find_or_create_by_name(name: 'Davidson, NC')
Location.find_or_create_by_name(name: 'Santa Barbara, CA')
Location.find_or_create_by_name(name: 'Sewanee, TN')
Location.find_or_create_by_name(name: 'Middlebury, VT')
Location.find_or_create_by_name(name: 'Los Angeles, CA')

cities = [
  "New York",
  "Los Angeles",
  "Chicago",
  "San Francisco",
  "Charlotte",
  "Raleigh-Durham",
  "Dallas-Fort Worth",
  "Boston",
  "Washington DC",
  "Baltimore",
  "Miami",
  "Nashville",
  "Seattle",
  "Denver",
  "San Diego",
  "Atlanta",
  "Philadelphia",
  "Houston",
  "Cincinnati",
  "Minneapolis"
]

cities.each do |city|
  c = City.find_or_create_by_name(city)
end

professional_fields = [
  "Accounting",
  "Art and Design",
  "Banking",
  "Business",
  "Communication",
  "Computer/ IT",
  "Consulting",
  "Education",
  "Entertainment",
  "Entrepreneurship",
  "Finance",
  "Government",
  "Health/Medicine",
  "Homemaker",
  "Human Resources",
  "Insurance",
  "Journalism and Writing",
  "Marketing",
  "Non Profit & Social Service",
  "Public Relations",
  "Real Estate",
  "Transportation"
]

professional_fields.each do |professional_field|
  pf = ProfessionalField.find_or_create_by_name(professional_field)
end

#super admin user
puts 'DEFAULT USERS'
puts 'Add Super Admin'
@super_admin = User.find_or_initialize_by_email(
  first_name: ENV['SUPER_ADMIN_FIRST_NAME'].dup,
  last_name: ENV['SUPER_ADMIN_LAST_NAME'].dup,
  email: ENV['SUPER_ADMIN_EMAIL'].dup,
  password: ENV['SUPER_ADMIN_PASSWORD'].dup,
  password_confirmation: ENV['SUPER_ADMIN_PASSWORD'].dup,
  graduation_year: '2005',
  major: 'Computer Science',
  location_id: @location.id,
)
@super_admin.save(validate: false)
@super_admin.add_role :super_admin
Profile.find_or_create_by_user_id(@super_admin.id, skills: 'Super Admin')

#university admin user
@university_admin = User.find_or_initialize_by_email(
  first_name: ENV['UNIVERSITY_ADMIN_FIRST_NAME'].dup,
  last_name: ENV['UNIVERSITY_ADMIN_LAST_NAME'].dup,
  email: ENV['UNIVERSITY_ADMIN_EMAIL'].dup,
  password: ENV['UNIVERSITY_ADMIN_PASSWORD'].dup,
  password_confirmation: ENV['UNIVERSITY_ADMIN_PASSWORD'].dup,
  graduation_year: '2005',
  major: 'Computer Science',
  location_id: @location.id,
)
@university_admin.save(validate: false)
@university_admin.add_role :university_admin
Profile.find_or_create_by_user_id(@university_admin.id, skills: 'University Admin')

#Universities
puts 'Adding Universities'
@university = University.find_or_create_by_name(name: 'Davidson College')
University.find_or_create_by_name(name: 'Westmont College')
University.find_or_create_by_name(name: 'Sewanee University')
University.find_or_create_by_name(name: 'Middlebury College')
University.find_or_create_by_name(name: 'Occidental College')

Dev.update_college_images

#Clubs
puts 'Adding Clubs'
Club.find_or_create_by_name(name: 'Sports Club', university_id: @university.id)

@super_admin.update_attributes(university_id: @university.id)
@university_admin.update_attributes(university_id: @university.id)
