package main

import (
	"beego-demo/models"
	_ "beego-demo/routers"

	"github.com/beego/beego/v2/client/orm"
	"github.com/beego/beego/v2/core/logs"
	"github.com/beego/beego/v2/server/web"
	_ "github.com/go-sql-driver/mysql"
)

func init() {
	// 数据库初始化
	orm.RegisterDriver("mysql", orm.DRMySQL)
	
	// 从配置文件读取数据库连接信息
	mysqluser, _ := web.AppConfig.String("mysqluser")
	mysqlpass, _ := web.AppConfig.String("mysqlpass")
	mysqlurls, _ := web.AppConfig.String("mysqlurls")
	mysqldb, _ := web.AppConfig.String("mysqldb")
	
	if mysqluser == "" {
		mysqluser = "root"
	}
	if mysqlpass == "" {
		mysqlpass = "password"
	}
	if mysqlurls == "" {
		mysqlurls = "127.0.0.1:3306"
	}
	if mysqldb == "" {
		mysqldb = "beego_demo"
	}
	
	dsn := mysqluser + ":" + mysqlpass + "@tcp(" + mysqlurls + ")/" + mysqldb + "?charset=utf8mb4&parseTime=true&loc=Local"
	
	// 注册数据库连接
	orm.RegisterDataBase("default", "mysql", dsn)
	
	// 注册模型
	orm.RegisterModel(new(models.User))
	
	// 开发模式下自动建表
	if web.BConfig.RunMode == "dev" {
		orm.RunSyncdb("default", false, true)
	}
	
	// 配置日志
	logs.SetLogger(logs.AdapterConsole)
	logs.SetLevel(logs.LevelInfo)
}

func main() {
	// 启动Web服务器
	web.Run()
}
