# Beego Demo 项目

这是一个基于Beego框架的完整演示项目，展示了Beego框架的核心功能和最佳实践。

## 项目特性

- **MVC架构**: 清晰的模型-视图-控制器分离
- **RESTful API**: 完整的用户和文章管理API
- **ORM支持**: 使用Beego ORM进行数据库操作
- **模板引擎**: 响应式Web界面
- **会话管理**: 用户登录状态管理
- **错误处理**: 统一的错误处理机制
- **分页功能**: 文章列表分页显示
- **搜索功能**: 文章标题搜索

## 项目结构

```
beego-demo/
├── conf/           # 配置文件
│   └── app.conf   # 应用配置
├── controllers/    # 控制器
│   ├── default.go # 主控制器
│   ├── user.go    # 用户控制器
│   ├── article.go # 文章控制器
│   └── error.go   # 错误控制器
├── models/         # 数据模型
│   ├── user.go    # 用户模型
│   └── article.go # 文章模型
├── routers/        # 路由配置
│   └── router.go  # 路由定义
├── views/          # 视图模板
│   ├── index.tpl  # 首页模板
│   ├── article_detail.tpl # 文章详情模板
│   ├── article_list.tpl   # 文章列表模板
│   └── 404.tpl    # 404错误页面
├── static/         # 静态文件目录
├── main.go         # 程序入口
├── go.mod          # Go模块文件
└── README.md       # 项目说明
```

## 环境要求

- Go 1.19+
- MySQL 5.7+

## 安装和运行

### 1. 克隆项目
```bash
git clone <repository-url>
cd beego-demo
```

### 2. 安装依赖
```bash
go mod tidy
```

### 3. 配置数据库
创建MySQL数据库：
```sql
CREATE DATABASE beego_demo CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

修改 `conf/app.conf` 中的数据库配置：
```ini
mysqluser = "your_username"
mysqlpass = "your_password"
mysqlurls = "127.0.0.1:3306"
mysqldb = "beego_demo"
```

### 4. 运行项目
```bash
go run main.go
```

或者编译后运行：
```bash
go build -o beego-demo main.go
./beego-demo
```

访问 http://localhost:8080 查看应用。

## API接口

### 用户相关
- `GET /api/users` - 获取用户列表
- `GET /api/users/:id` - 获取单个用户
- `POST /api/users` - 创建用户
- `PUT /api/users/:id` - 更新用户
- `DELETE /api/users/:id` - 删除用户
- `POST /api/login` - 用户登录
- `POST /api/logout` - 用户登出

### 文章相关
- `GET /api/articles` - 获取文章列表
- `GET /api/articles/:id` - 获取单个文章
- `POST /api/articles` - 创建文章（需要登录）
- `PUT /api/articles/:id` - 更新文章（需要登录且为作者）
- `DELETE /api/articles/:id` - 删除文章（需要登录且为作者）

## 示例数据

### 创建用户
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "email": "admin@example.com",
    "password": "123456"
  }'
```

### 用户登录
```bash
curl -X POST http://localhost:8080/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "123456"
  }'
```

### 创建文章
```bash
curl -X POST http://localhost:8080/api/articles \
  -H "Content-Type: application/json" \
  -H "Cookie: beegosessionID=your_session_id" \
  -d '{
    "title": "我的第一篇文章",
    "content": "这是文章的内容...",
    "summary": "文章摘要",
    "status": 1
  }'
```

## 开发指南

### 添加新的控制器
1. 在 `controllers/` 目录下创建新的控制器文件
2. 继承 `web.Controller`
3. 在 `routers/router.go` 中添加路由

### 添加新的模型
1. 在 `models/` 目录下创建模型文件
2. 定义结构体和相关方法
3. 在 `main.go` 中注册模型

### 添加新的视图
1. 在 `views/` 目录下创建模板文件
2. 使用Go模板语法编写页面
3. 在控制器中设置模板名称

## 部署

### 使用Docker部署
```dockerfile
FROM golang:1.19-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
COPY --from=builder /app/conf ./conf
COPY --from=builder /app/views ./views
COPY --from=builder /app/static ./static
EXPOSE 8080
CMD ["./main"]
```

### 编译部署
```bash
# 编译
go build -o beego-demo main.go

# 运行
./beego-demo
```

## 贡献

欢迎提交Issue和Pull Request来改进这个项目。

## 许可证

MIT License
