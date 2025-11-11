<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - Beego Demo</title>
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
        
        .register-container {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .register-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 0.5rem;
        }
        
        .register-subtitle {
            color: #666;
            font-size: 0.9rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #333;
            font-weight: 500;
        }
        
        .form-input {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn {
            width: 100%;
            padding: 0.75rem;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background: #5a6fd8;
        }
        
        .btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        
        .register-footer {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #eee;
        }
        
        .register-footer a {
            color: #667eea;
            text-decoration: none;
        }
        
        .register-footer a:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 0.75rem;
            margin-bottom: 1rem;
            border-radius: 5px;
            display: none;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .loading {
            display: none;
            text-align: center;
            margin-top: 1rem;
        }
        
        .spinner {
            border: 2px solid #f3f3f3;
            border-top: 2px solid #667eea;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            animation: spin 1s linear infinite;
            display: inline-block;
            margin-right: 0.5rem;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .password-hint {
            font-size: 0.8rem;
            color: #666;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1 class="register-title">用户注册</h1>
            <p class="register-subtitle">创建您的新账户</p>
        </div>
        
        <div id="alert" class="alert"></div>
        
        <form id="registerForm">
            <div class="form-group">
                <label class="form-label" for="username">用户名</label>
                <input type="text" id="username" name="username" class="form-input" required>
                <div class="password-hint">用户名长度3-20个字符</div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="email">邮箱</label>
                <input type="email" id="email" name="email" class="form-input" required>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="password">密码</label>
                <input type="password" id="password" name="password" class="form-input" required>
                <div class="password-hint">密码长度至少6个字符</div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="confirmPassword">确认密码</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required>
            </div>
            
            <button type="submit" class="btn" id="registerBtn">注册</button>
        </form>
        
        <div class="loading" id="loading">
            <div class="spinner"></div>
            正在注册...
        </div>
        
        <div class="register-footer">
            <p>已有账户？ <a href="/login">立即登录</a></p>
        </div>
    </div>

    <script>
        document.getElementById('registerForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const username = document.getElementById('username').value;
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const alertDiv = document.getElementById('alert');
            const registerBtn = document.getElementById('registerBtn');
            const loading = document.getElementById('loading');
            
            // 基本验证
            if (!username || !email || !password || !confirmPassword) {
                showAlert('请填写所有字段', 'error');
                return;
            }
            
            if (username.length < 3 || username.length > 20) {
                showAlert('用户名长度应为3-20个字符', 'error');
                return;
            }
            
            if (password.length < 6) {
                showAlert('密码长度至少6个字符', 'error');
                return;
            }
            
            if (password !== confirmPassword) {
                showAlert('两次输入的密码不一致', 'error');
                return;
            }
            
            // 显示加载状态
            registerBtn.disabled = true;
            loading.style.display = 'block';
            alertDiv.style.display = 'none';
            
            try {
                const response = await fetch('/api/users', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        username: username,
                        email: email,
                        password: password
                    })
                });
                
                const data = await response.json();
                
                if (data.code === 201) {
                    showAlert('注册成功，正在跳转到登录页面...', 'success');
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 2000);
                } else {
                    showAlert(data.message || '注册失败', 'error');
                }
            } catch (error) {
                showAlert('网络错误，请重试', 'error');
            } finally {
                registerBtn.disabled = false;
                loading.style.display = 'none';
            }
        });
        
        function showAlert(message, type) {
            const alertDiv = document.getElementById('alert');
            alertDiv.textContent = message;
            alertDiv.className = 'alert alert-' + type;
            alertDiv.style.display = 'block';
        }
    </script>
</body>
</html>
