defmodule WeberRouteTest do
  use ExUnit.Case

  import Weber.Route

  test "Test for Weber.Route.on and Weber.Route.otherwise" do
    route1 = on("ANY", "/", :Controller1, :main_action)
          |> on("GET", "/user/0xAX/add", :Controller1, :action2)
          |> on("POST", "/user/:user/delete", :Controller1, :action2)
          |> resources(:Photos)
          |> redirect("GET", "/redirect", "/")

    assert(route1 == [[method: "ANY", path: "/", controller: :Controller1, action: :main_action],
                 [method: "GET", path: "/user/0xAX/add", controller: :Controller1, action: :action2],
                 [method: "POST", path: "/user/:user/delete", controller: :Controller1, action: :action2],
                 [method: "GET", path: "/photos", controller: :Photos, action: :index],
                 [method: "GET", path: "/photos/new", controller: :Photos, action: :new],
                 [method: "POST", path: "/photos", controller: :Photos, action: :create],
                 [method: "GET", path: "/photos/:id", controller: :Photos, action: :show],
                 [method: "GET", path: "/photos/:id/edit", controller: :Photos, action: :edit],
                 [method: "PUT", path: "/photos/:id", controller: :Photos, action: :update],
                 [method: "DELETE", path: "/photos/:id", controller: :Photos, action: :destroy],
                 [method: "GET", path: "/redirect", redirect_path: "/"]])
    
    route2 = resources(:Test.Photos)

    assert route2 == [[method: "GET", path: "/test/photos", controller: Test.Photos, action: :index], 
                      [method: "GET", path: "/test/photos/new", controller: Test.Photos, action: :new], 
                      [method: "POST", path: "/test/photos", controller: Test.Photos, action: :create], 
                      [method: "GET", path: "/test/photos/:id", controller: Test.Photos, action: :show], 
                      [method: "GET", path: "/test/photos/:id/edit", controller: Test.Photos, action: :edit], 
                      [method: "PUT", path: "/test/photos/:id", controller: Test.Photos, action: :update], 
                      [method: "DELETE", path: "/test/photos/:id", controller: Test.Photos, action: :destroy]]

  end

  test "Test for Weber.Route.match_routes_helper" do
    r = on("ANY", "/", :Controller1, :main_action)
      |> on("POST", "/user/0xAX/add", :Controller1, :action2)
      |> on("POST", "/user/:user/delete", :Controller1, :action2)
      |> redirect("ANY", "/weber", "/")
      |> on("GET", %r{/hello/([\w]+)}, :Controller1, :action2)

   assert match_routes("/main.html", r, "GET") == []
   assert match_routes("/user/0xAX", r, "POST") == []
   assert match_routes("/", r, "ANY") == [[method: "ANY", path: "/", controller: :Controller1, action: :main_action]]
   assert match_routes("/user/0xAX/add/user2", r, "GET") == []
   assert match_routes("/user/0xAX/add/", r, "POST") == [[method: "POST", path: "/user/0xAX/add", controller: :Controller1, action: :action2]]
   assert match_routes("/user/0xAX/add?role=admin", r, "POST") == [[method: "POST", path: "/user/0xAX/add", controller: :Controller1, action: :action2]]
   assert match_routes("/user/0xAX/delete?role=admin", r, "POST") == [[method: "POST", path: "/user/:user/delete", controller: :Controller1, action: :action2]]
   assert match_routes("/user/0xAX/remove?role=admin", r, "ANY") == []
   assert match_routes("/weber", r, "ANY") == [[method: "ANY", path: "/weber", redirect_path: "/"]]
   assert match_routes("/home", r, "ANY") == []
   assert match_routes("/hello/world", r, "GET") == [[method: "GET", path: %r"/hello/([\w]+)", controller: :Controller1, action: :action2]]

  end

  test "Route reverse test" do
    assert link(:TestTestTest.Main, :add_username_action, [username: "user"]) == "/add/user"
    assert link(:TestTestTest.Main, :action, []) == "/weber"
    assert link(:TestTestTest.Main, :delete_username_action, [id: 5, username: "user"]) == "/delete/user/id/5"
  end

end
