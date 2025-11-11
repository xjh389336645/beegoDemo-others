<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户列表 - Beego Demo</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f5f5;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* 头部导航 */
        .header {
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 1rem 0;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: #333;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .welcome-text {
            color: #666;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }

        /* 主要内容 */
        .main-content {
            padding: 2rem 0;
        }

        .page-header {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .page-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            color: #666;
        }

        /* 用户表格 */
        .users-table {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th,
        .table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #333;
        }

        .table tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }

        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #667eea;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        /* 分页 */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 2rem;
        }

        .pagination a,
        .pagination span {
            padding: 0.5rem 1rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-decoration: none;
            color: #333;
        }

        .pagination a:hover {
            background: #f8f9fa;
        }

        .pagination .current {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        .empty-state h3 {
            margin-bottom: 1rem;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                gap: 1rem;
            }

            .table {
                font-size: 0.875rem;
            }

            .table th,
            .table td {
                padding: 0.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- 头部导航 -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">Beego Demo</div>
                <div class="user-info">
                    {{if .CurrentUser}}
                    <span class="welcome-text">欢迎，{{.CurrentUser.Username}}</span>
                    <button class="btn btn-danger btn-sm" onclick="logout()">退出登录</button>
                    {{end}}
                </div>
            </div>
        </div>
    </header>

    <!-- 主要内容 -->
    <main class="main-content">
        <div class="container">
            <!-- 页面标题 -->
            <div class="page-header">
                <h1 class="page-title">用户管理</h1>
                <p class="page-subtitle">系统中共有 {{.Total}} 个用户</p>
            </div>

            <!-- 用户列表 -->
            {{if .Users}}
            <div class="users-table">
                <table class="table">
                    <thead>
                        <tr>
                            <th>头像</th>
                            <th>用户名</th>
                            <th>邮箱</th>
                            <th>状态</th>
                            <th>注册时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        {{range .Users}}
                        <tr>
                            <td>
                                <div class="avatar">
                                    {{if .Avatar}}
                                    <img src="{{.Avatar}}" alt="{{.Username}}" style="width: 100%; height: 100%; border-radius: 50%;">
                                    {{else}}
                                    {{.Username}}
                                    {{end}}
                                </div>
                            </td>
                            <td>{{.Username}}</td>
                            <td>{{.Email}}</td>
                            <td>
                                {{if eq .Status 1}}
                                <span class="status-badge status-active">正常</span>
                                {{else}}
                                <span class="status-badge status-inactive">禁用</span>
                                {{end}}
                            </td>
                            <td>{{.Created.Format "2006-01-02 15:04"}}</td>
                            <td>
                                <button class="btn btn-primary btn-sm" onclick="viewUser({{.Id}})">查看</button>
                                {{if ne .Id $.CurrentUser.Id}}
                                <button class="btn btn-danger btn-sm" onclick="deleteUser({{.Id}}, '{{.Username}}')">删除</button>
                                {{end}}
                            </td>
                        </tr>
                        {{end}}
                    </tbody>
                </table>
            </div>

            <!-- 分页 -->
            {{if gt .TotalPages 1}}
            <div class="pagination">
                {{if gt .CurrentPage 1}}
                <a href="/users?page={{.PrevPage}}">上一页</a>
                {{end}}

                <span class="current">第 {{.CurrentPage}} 页</span>

                {{if lt .CurrentPage .TotalPages}}
                <a href="/users?page={{.NextPage}}">下一页</a>
                {{end}}
            </div>
            {{end}}
            {{else}}
            <div class="users-table">
                <div class="empty-state">
                    <h3>暂无用户</h3>
                    <p>系统中还没有注册用户</p>
                </div>
            </div>
            {{end}}
        </div>
    </main>

    <script>
        // 退出登录
        async function logout() {
            if (confirm('确定要退出登录吗？')) {
                try {
                    const response = await fetch('/api/logout', {
                        method: 'POST'
                    });

                    if (response.ok) {
                        window.location.href = '/login';
                    } else {
                        alert('退出登录失败');
                    }
                } catch (error) {
                    alert('网络错误');
                }
            }
        }

        // 查看用户详情
        function viewUser(userId) {
            // 这里可以实现查看用户详情的功能
            alert('查看用户 ID: ' + userId + ' 的详情');
        }

        // 删除用户
        async function deleteUser(userId, username) {
            if (confirm('确定要删除用户 "' + username + '" 吗？此操作不可恢复！')) {
                try {
                    const response = await fetch('/api/users/' + userId, {
                        method: 'DELETE'
                    });

                    const data = await response.json();

                    if (data.code === 200) {
                        alert('用户删除成功');
                        location.reload();
                    } else {
                        alert(data.message || '删除失败');
                    }
                } catch (error) {
                    alert('网络错误');
                }
            }
        }
    </script>
</body>
</html>
