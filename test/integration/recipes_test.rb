require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Mach", email: "brian@tythis.com")
    @recipe = Recipe.create(name: "vegetable sautee", description: "great vegetable sautee.  Add vegetables and oil", chef: @chef)
    @recipe2 = @chef.recipes.build(name: "chicken sautee", description: "great chicken dish")
    @recipe2.save
  end

  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name.titleize
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name.titleize
  end

  test "should get recipes show" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name.titleize, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
  end

end
