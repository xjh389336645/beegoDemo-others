<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>页面未找到 - Beego Demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .error-page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .error-content {
            text-align: center;
        }
        .error-code {
            font-size: 8rem;
            font-weight: bold;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="error-page">
        <div class="error-content">
            <div class="error-code">404</div>
            <h1 class="h2 mb-3">页面未找到</h1>
            <p class="text-muted mb-4">{{.content}}</p>
            <div>
                <a href="/" class="btn btn-primary me-2">返回首页</a>
                <a href="javascript:history.back()" class="btn btn-outline-secondary">返回上页</a>
            </div>
        </div>
    </div>
</body>
</html>
