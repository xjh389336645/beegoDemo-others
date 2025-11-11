package controllers

import (
	"github.com/beego/beego/v2/server/web"
)

// ErrorController 错误处理控制器
type ErrorController struct {
	web.Controller
}

// Error404 处理404错误
func (c *ErrorController) Error404() {
	c.Data["content"] = "页面未找到"
	c.TplName = "404.tpl"
}

// Error500 处理500错误
func (c *ErrorController) Error500() {
	c.Data["content"] = "服务器内部错误"
	c.TplName = "500.tpl"
}

// ErrorGeneric 处理通用错误
func (c *ErrorController) ErrorGeneric() {
	c.Data["content"] = "发生了未知错误"
	c.TplName = "error.tpl"
}
