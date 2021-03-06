require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :first_name => "Example",
      :last_name => "User",
      :email => "user@example.com",
      :graduation_year => "2005",
      :major => "Computer Engineering",
      :password => "changeme",
      :password_confirmation => "changeme",
      university_id: '1',
      graduation_year: '2005',
      major: 'Computer Science',
      city_id: 1,
      state: 'IL'
    }
  end

  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

  end

  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end

  describe '#relatable?' do

    let!(:university) { FactoryGirl.create(:university) }
    let(:user) { FactoryGirl.create(:user, university_id: university.id) }

    context 'with same university' do

      let(:user2) { FactoryGirl.create(:user, university_id: university.id) }

      it "should be relatable" do
        expect(user.relatable?(user2)).to be_true
      end

   end

   context 'with different universities' do

     let(:university2) { FactoryGirl.create(:university) }
     let(:user2)       { FactoryGirl.create(:user, university_id: university2.id) }

     it "should not be relatable" do
       expect(user.relatable?(user2)).to_not be_true
     end

   end

   context 'with self' do

     it "should not be relatable" do
       expect(user.relatable?(user)).to_not be_true
     end

   end

   context 'already related' do

     let!(:user2)       { FactoryGirl.create(:user, university_id: university.id) }
     let!(:relationship) { FactoryGirl.create(:relationship, user_id: user.id, relation_id: user2.id) }

     it "should not be relateable" do
       expect(user.relatable?(user2)).to_not be_true
     end

   end


  end

  describe '#search' do

    let!(:user) { FactoryGirl.create(:user) }

    context 'without filters' do

      #it "should return one user do" do
      #  expect(User.search(user.email)).to eq([user])
      #end

    end

    context 'with type filter' do

      it "should return one user" do
        expect(User.search(nil, {by_alumni_student: true})).to eq([user])
      end

    end

    context 'with graduation_year filter' do

      it "should return a user" do
        expect(User.search(nil, {by_graduation_year: 2008})).to eq([user])
      end

    end

    context 'with location filter' do

      let(:location) { FactoryGirl.create(:location) }

      it "should return one user" do
        expect(User.search(nil, {by_location: location.id})).to eq([user])
      end

    end

    context 'with major filter' do

      it "should return one user" do
        expect(User.search(nil, {by_major: "CS"})).to eq([user])
      end

    end

    context 'with field filter' do

      let(:professional_field) { FactoryGirl.create(:professional_field) }

      it "should return one user" do
        expect(User.search(nil, {by_professional_field: professional_field.id})).to eq([user])
      end

    end

  end


end
