require 'spec_helper'

describe RelationshipsController do

  context "POST to created" do

    let!(:user)         { FactoryGirl.create(:user) }
    let!(:user2)        { FactoryGirl.create(:user) }

    describe "when successful" do

      before do
        sign_in user2
        post :create, relationship: {relation_id: user2.id, message: 'hi jim, please connect with me'}
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(user_path(user2)) }

    end

  end

  context "POST to accept" do

    let!(:user)         { FactoryGirl.create(:user) }
    let!(:user2)        { FactoryGirl.create(:user) }
    let!(:relationship) { Relationship.request(user, user2) }

    describe "when successful" do

      before do
        sign_in user2
        post :accept, id: relationship.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(user_path(user2)) }

    end

  end


  context "POST to decline" do

    let!(:user)         { FactoryGirl.create(:user) }
    let!(:user2)        { FactoryGirl.create(:user) }
    let!(:relationship) { Relationship.request(user, user2) }


    describe "when successful" do

      before do
        sign_in user2
        post :decline, id: relationship.id
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(user_path(user2)) }

    end

  end

  context "POST to refer" do

    let!(:user)         { FactoryGirl.create(:user) }
    let!(:user2)        { FactoryGirl.create(:user) }
    let!(:user3)        { FactoryGirl.create(:user) }
    let!(:relationship) { Relationship.request(user, user2) }

    describe 'when successful' do

      before do
        sign_in user2
        post :refer, id: relationship.id, relation_ids: user3.id, message: 'hi jim, referrred to mary'
      end

      it { should respond_with(:redirect) }
      it { should redirect_to(user_path(user2)) }

      #it "should assign to referred relationship that is pending" do
        #expect(assigns(:refer_relationship).recommended?).to be_true
      #end

      it "should decline the relationship" do
        expect(assigns(:relationship).declined?).to be_true
      end

    end

  end

  context 'POST to accept_recommendation' do

    let!(:user)         { FactoryGirl.create(:user) }
    let!(:user2)        { FactoryGirl.create(:user) }
    let!(:user3)        { FactoryGirl.create(:user) }
    let!(:relationship) { Relationship.request(user, user2) }

    before do
      relationship.recommend!(user3)
      recommended_relationship = Relationship.find_by_user_id_and_relation_id(user.id, user3.id)
      sign_in user
      post :accept_recommendation, id: recommended_relationship
    end

    it "should assign the relationship" do
      #expects(assigns(relationship).pending?).to be_true
    end

  end

end
