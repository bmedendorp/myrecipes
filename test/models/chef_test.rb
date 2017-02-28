require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: "Mach", email: "brian@tythis.com")
  end

  test "chef should be valid" do
    assert @chef.valid?
  end

  test "chefname should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "chefname shouldn't be less than 3 characters" do
    @chef.chefname = "a" * 2
    assert_not @chef.valid?
  end

  test "chefname shouldn't be more than 20 characters" do
    @chef.chefname = "a" * 21
    assert_not @chef.valid?
  end

  test "email shouldn't be less than 5 characters" do 
    @chef.email = "a" * 4
    assert_not @chef.valid?
  end

  test "email shouldn't be more than 100 characters" do 
    @chef.email = "a" * 99 + "@test.com"
    assert_not @chef.valid?
  end

  test "email should accept valid format" do 
    valid_emails = %w[user@example.com MASHRUR@gmail.com M.first@yahoo.ca john+smith@co.uk.org]
    valid_emails.each do |valid|
      @chef.email = valid
      assert @chef.valid?, "#{valid.inspect} should be valid"
    end
  end

  test "email should reject invalid format" do
    invalid_emails = %w[test test.com test@test test@test,com test@test. test@foo+bar.com]
    invalid_emails.each do |invalid|
      @chef.email = invalid
      assert_not @chef.valid?, "#{invalid.inspect} should be inavlid"
    end    
  end

  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email should be lowercase before hitting db" do
    mixed_email = "BmeDenDorp@Test.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

end
