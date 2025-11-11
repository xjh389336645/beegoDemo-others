package routers

import (
	"beego-demo/controllers"

	"github.com/beego/beego/v2/server/web"
)

func init() {
	// 主页路由
	web.Router("/", &controllers.MainController{})
	web.Router("/login", &controllers.MainController{}, "get:Login")
	web.Router("/register", &controllers.MainController{}, "get:Register")
	web.Router("/users", &controllers.MainController{}, "get:UserList")

	// API路由 - 用户相关
	web.Router("/api/users", &controllers.UserController{}, "get:GetUsers;post:CreateUser")
	web.Router("/api/users/:id", &controllers.UserController{}, "get:GetUser;put:UpdateUser;delete:DeleteUser")
	web.Router("/api/login", &controllers.UserController{}, "post:Login")
	web.Router("/api/logout", &controllers.UserController{}, "post:Logout")

	// 静态文件路由
	web.SetStaticPath("/static", "static")

	// favicon路由
	web.Router("/favicon.ico", &controllers.MainController{}, "get:Favicon")

	// 错误页面
	web.ErrorController(&controllers.ErrorController{})
}
