package controllers

import (
	"beego-demo/models"
	"encoding/json"
	"strconv"

	"github.com/beego/beego/v2/core/logs"
	"github.com/beego/beego/v2/server/web"
)

// UserController 用户控制器
type UserController struct {
	web.Controller
}

// GetUsers 获取用户列表 - GET /api/users
func (c *UserController) GetUsers() {
	pageStr := c.GetString("page", "1")
	pageSizeStr := c.GetString("pageSize", "10")

	page, _ := strconv.Atoi(pageStr)
	pageSize, _ := strconv.Atoi(pageSizeStr)

	if page < 1 {
		page = 1
	}
	if pageSize < 1 || pageSize > 100 {
		pageSize = 10
	}

	users, total, err := models.GetAllUsers(page, pageSize)
	if err != nil {
		logs.Error("获取用户列表失败:", err)
		c.Data["json"] = map[string]interface{}{
			"code":    500,
			"message": "获取用户列表失败",
			"error":   err.Error(),
		}
		c.Ctx.Output.SetStatus(500)
	} else {
		c.Data["json"] = map[string]interface{}{
			"code":    200,
			"message": "success",
			"data": map[string]interface{}{
				"users":    users,
				"total":    total,
				"page":     page,
				"pageSize": pageSize,
			},
		}
	}
	c.ServeJSON()
}

// GetUser 获取单个用户 - GET /api/users/:id
func (c *UserController) GetUser() {
	idStr := c.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"code":    400,
			"message": "无效的用户ID",
		}
		c.Ctx.Output.SetStatus(400)
		c.ServeJSON()
		return
	}

	user, err := models.GetUser(id)
	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"code":    404,
			"message": "用户不存在",
		}
		c.Ctx.Output.SetStatus(404)
	} else {
		c.Data["json"] = map[string]interface{}{
			"code":    200,
			"message": "success",
			"data":    user,
		}
	}
	c.ServeJSON()
}

// CreateUser 创建用户 - POST /api/users
func (c *UserController) CreateUser() {
	var user models.User

	// 打印请求体用于调试
	logs.Info("Request Body:", string(c.Ctx.Input.RequestBody))

	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &user); err != nil {
		logs.Error("JSON解析失败:", err)
		c.Data["json"] = map[string]interface{}{
			"code":    400,
			"message": "无效的JSON数据",
			"error":   err.Error(),
		}
		c.Ctx.Output.SetStatus(400)
		c.ServeJSON()
		return
	}

	// 打印解析后的用户数据
	logs.Info("解析后的用户数据:", user)

	// 基本验证
	if user.Username == "" {
		c.Data["json"] = map[string]interface{}{
			"code":    400,
			"message": "用户名不能为空",
		}
		c.Ctx.Output.SetStatus(400)
		c.ServeJSON()
		return
	}

	if user.Email == "" {
		c.Data["json"] = map[string]interface{}{
			"code":    400,
			"message": "邮箱不能为空",
		}
		c.Ctx.Output.SetStatus(400)
		c.ServeJSON()
		return
	}

	if user.Password == "" {
		c.Data["json"] = map[string]interface{}{
			"code":    400,
			"message": "密码不能为空",
		}
		c.Ctx.Output.SetStatus(400)
		c.ServeJSON()
		return
	}
	user.Status = 1
	if err := models.AddUser(&user); err != nil {
		logs.Error("创建用户失败:", err)
		c.Data["json"] = map[string]interface{}{
			"code":    500,
			"message": err.Error(),
		}
		c.Ctx.Output.SetStatus(500)
	} else {
		c.Data["json"] = map[string]interface{}{
			"code":    201,
			"message": "用户创建成功",
			"data":    user,
		}
		c.Ctx.Output.SetStatus(201)
	}
	c.ServeJSON()
}

// UpdateUser 更新用户 - PUT /api/users/:id
func (c *UserController) UpdateUser() {
	idStr := c.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"code":    400,
			"message": "无效的用户ID",
		}
		c.Ctx.Output.SetStatus(400)
		c.ServeJSON()
		return
	}

	// 检查用户是否存在
	existUser, err := models.GetUser(id)
	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"code":    404,
			"message": "用户不存在",
		}
		c.Ctx.Output.SetStatus(404)
		c.ServeJSON()
		return
	}

	var updateData map[string]interface{}
	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &updateData); err != nil {
		c.Data["json"] = map[string]interface{}{
			"code":    400,
			"message": "无效的JSON数据",
			"error":   err.Error(),
		}
		c.Ctx.Output.SetStatus(400)
		c.ServeJSON()
		return
	}

	// 更新字段
	if username, ok := updateData["username"].(string); ok && username != "" {
		existUser.Username = username
	}
	if email, ok := updateData["email"].(string); ok && email != "" {
		existUser.Email = email
	}
	if avatar, ok := updateData["avatar"].(string); ok {
		existUser.Avatar = avatar
	}
	if status, ok := updateData["status"].(float64); ok {
		existUser.Status = int(status)
	}

	if err := models.UpdateUser(existUser); err != nil {
		logs.Error("更新用户失败:", err)
		c.Data["json"] = map[string]interface{}{
			"code":    500,
			"message": "更新用户失败",
			"error":   err.Error(),
		}
		c.Ctx.Output.SetStatus(500)
	} else {
		c.Data["json"] = map[string]interface{}{
			"code":    200,
			"message": "用户更新成功",
			"data":    existUser,
		}
	}
	c.ServeJSON()
}

// DeleteUser 删除用户 - DELETE /api/users/:id
func (c *UserController) DeleteUser() {
	idStr := c.Ctx.Input.Param(":id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"code":    400,
			"message": "无效的用户ID",
		}
		c.Ctx.Output.SetStatus(400)
		c.ServeJSON()
		return
	}

	if err := models.DeleteUser(id); err != nil {
		logs.Error("删除用户失败:", err)
		c.Data["json"] = map[string]interface{}{
			"code":    500,
			"message": "删除用户失败",
			"error":   err.Error(),
		}
		c.Ctx.Output.SetStatus(500)
	} else {
		c.Data["json"] = map[string]interface{}{
			"code":    200,
			"message": "用户删除成功",
		}
	}
	c.ServeJSON()
}

// Login 用户登录 - POST /api/login
func (c *UserController) Login() {
	var loginData struct {
		Username string `json:"username"`
		Password string `json:"password"`
	}

	if err := json.Unmarshal(c.Ctx.Input.RequestBody, &loginData); err != nil {
		c.Data["json"] = map[string]interface{}{
			"code":    400,
			"message": "无效的JSON数据",
		}
		c.Ctx.Output.SetStatus(400)
		c.ServeJSON()
		return
	}

	user, err := models.ValidateUser(loginData.Username, loginData.Password)
	if err != nil {
		c.Data["json"] = map[string]interface{}{
			"code":    401,
			"message": err.Error(),
		}
		c.Ctx.Output.SetStatus(401)
	} else {
		// 设置会话
		c.SetSession("user_id", user.Id)
		c.SetSession("username", user.Username)

		c.Data["json"] = map[string]interface{}{
			"code":    200,
			"message": "登录成功",
			"data":    user,
		}
	}
	c.ServeJSON()
}

// Logout 用户登出 - POST /api/logout
func (c *UserController) Logout() {
	c.DelSession("user_id")
	c.DelSession("username")

	c.Data["json"] = map[string]interface{}{
		"code":    200,
		"message": "登出成功",
	}
	c.ServeJSON()
}
