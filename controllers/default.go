package controllers

import (
	"beego-demo/models"
	"strconv"

	"github.com/beego/beego/v2/core/logs"
	"github.com/beego/beego/v2/server/web"
)

// MainController 主控制器
type MainController struct {
	web.Controller
}

// Get 首页 - 检查登录状态
func (c *MainController) Get() {
	// 检查用户是否已登录
	userId := c.GetSession("user_id")
	if userId == nil {
		// 未登录，跳转到登录页面
		c.TplName = "login.tpl"
		return
	}

	// 已登录，显示用户列表
	c.Redirect("/users", 302)
}

// Login 显示登录页面
func (c *MainController) Login() {
	c.TplName = "login.tpl"
}

// Register 显示注册页面
func (c *MainController) Register() {
	c.TplName = "register.tpl"
}

// UserList 用户列表页面
func (c *MainController) UserList() {
	// 检查用户是否已登录
	userId := c.GetSession("user_id")
	if userId == nil {
		c.Redirect("/login", 302)
		return
	}

	pageStr := c.GetString("page", "1")
	page, _ := strconv.Atoi(pageStr)
	if page < 1 {
		page = 1
	}

	pageSize := 10
	users, total, err := models.GetAllUsers(page, pageSize)
	if err != nil {
		logs.Error("获取用户列表失败:", err)
		users = []*models.User{}
		total = 0
	}

	// 计算分页信息
	totalPages := int((total + int64(pageSize) - 1) / int64(pageSize))
	prevPage := page - 1
	nextPage := page + 1
	if prevPage < 1 {
		prevPage = 1
	}
	if nextPage > totalPages {
		nextPage = totalPages
	}

	// 获取当前登录用户信息
	currentUser, _ := models.GetUser(userId.(int))

	c.Data["Users"] = users
	c.Data["CurrentPage"] = page
	c.Data["TotalPages"] = totalPages
	c.Data["Total"] = total
	c.Data["PrevPage"] = prevPage
	c.Data["NextPage"] = nextPage
	c.Data["CurrentUser"] = currentUser
	c.TplName = "user_list.tpl"
}

// Favicon 处理favicon请求
func (c *MainController) Favicon() {
	c.Ctx.Output.Header("Content-Type", "image/x-icon")
	c.Ctx.Output.Body([]byte(""))
}


