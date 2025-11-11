<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Beego Demo - 用户管理系统</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .welcome-container {
            background: white;
            padding: 3rem;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            text-align: center;
            max-width: 500px;
            width: 100%;
        }

        .welcome-title {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 1rem;
        }

        .welcome-subtitle {
            color: #666;
            font-size: 1.1rem;
            margin-bottom: 2rem;
        }

        .btn {
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 0.5rem;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #667eea;
            color: white;
        }

        .btn-primary:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .features {
            margin-top: 2rem;
            text-align: left;
        }

        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            color: #666;
        }

        .feature-icon {
            width: 20px;
            height: 20px;
            background: #667eea;
            border-radius: 50%;
            margin-right: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.8rem;
        }
    </style>
</head>
<body>
    <div class="welcome-container">
        <h1 class="welcome-title">欢迎使用</h1>
        <h2 class="welcome-subtitle">Beego 用户管理系统</h2>

        <div>
            <a href="/login" class="btn btn-primary">登录</a>
            <a href="/register" class="btn btn-secondary">注册</a>
        </div>

        <div class="features">
            <div class="feature-item">
                <div class="feature-icon">✓</div>
                <span>用户注册和登录</span>
            </div>
            <div class="feature-item">
                <div class="feature-icon">✓</div>
                <span>用户列表管理</span>
            </div>
            <div class="feature-item">
                <div class="feature-icon">✓</div>
                <span>基于Beego框架</span>
            </div>
            <div class="feature-item">
                <div class="feature-icon">✓</div>
                <span>RESTful API接口</span>
            </div>
        </div>
    </div>
</body>
</html>
