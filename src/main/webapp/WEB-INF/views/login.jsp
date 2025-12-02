<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - GenZ Beats</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Poppins", sans-serif;
        }
        
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: url('${pageContext.request.contextPath}/assets/bg/bg_login.png') no-repeat;
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
        }
        
        .wrapper {
            width: 420px;
            background: transparent;
            border: 2px solid rgba(255, 255, 255, .2);
            backdrop-filter: blur(20px);
            color: #fff;
            border-radius: 12px;
            padding: 30px 40px;
            box-shadow: 0 0 30px rgba(0, 0, 0, .5);
        }
        
        .wrapper h1 {
            font-size: 36px;
            text-align: center;
            margin-bottom: 10px;
        }
        
        .wrapper .subtitle {
            text-align: center;
            font-size: 14px;
            margin-bottom: 20px;
            opacity: 0.9;
        }
        
        .wrapper .input-box {
            position: relative;
            width: 100%;
            height: 50px;
            margin: 30px 0;
        }
        
        .input-box input {
            width: 100%;
            height: 100%;
            background: transparent;
            border: none;
            outline: none;
            border: 2px solid rgba(255, 255, 255, .2);
            border-radius: 40px;
            font-size: 16px;
            color: #fff;
            padding: 20px 45px 20px 20px;
        }
        
        .input-box input::placeholder {
            color: rgba(255, 255, 255, .8);
        }
        
        .input-box i {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 20px;
        }
        
        .wrapper .remember-forgot {
            display: flex;
            justify-content: space-between;
            font-size: 14.5px;
            margin: -15px 0 15px;
        }
        
        .remember-forgot label input {
            accent-color: #fff;
            margin-right: 3px;
        }
        
        .remember-forgot a {
            color: #fff;
            text-decoration: none;
        }
        
        .remember-forgot a:hover {
            text-decoration: underline;
        }
        
        .wrapper .btn {
            width: 100%;
            height: 45px;
            background: #fff;
            border: none;
            outline: none;
            border-radius: 40px;
            box-shadow: 0 0 10px rgba(0, 0, 0, .1);
            cursor: pointer;
            font-size: 16px;
            color: #333;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .wrapper .btn:hover {
            background: rgba(255, 255, 255, 0.9);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, .3);
        }
        
        .wrapper .register-link {
            font-size: 14.5px;
            text-align: center;
            margin: 20px 0 15px;
        }
        
        .register-link p a {
            color: #fff;
            text-decoration: none;
            font-weight: 600;
        }
        
        .register-link p a:hover {
            text-decoration: underline;
        }
        
        .error-message {
            background: rgba(255, 77, 77, 0.9);
            color: #fff;
            padding: 12px;
            border-radius: 40px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            border: 2px solid rgba(255, 255, 255, .2);
        }
        
        @media (max-width: 480px) {
            .wrapper {
                width: 90%;
                padding: 25px 30px;
            }
            
            .wrapper h1 {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <form method="post" action="${pageContext.request.contextPath}/login">
            <h1><i class='bx bxs-music'></i> Login</h1>
            <p class="subtitle">Chào mừng bạn đến với GenZ Beats</p>
            
            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class='bx bx-error-circle'></i> ${error}
                </div>
            </c:if>
            
            <div class="input-box">
                <input type="text" name="username" placeholder="Username" required autofocus>
                <i class='bx bxs-user'></i>
            </div>
            
            <div class="input-box">
                <input type="password" name="password" placeholder="Password" required>
                <i class='bx bxs-lock-alt'></i>
            </div>
            
            <div class="remember-forgot">
                <label><input type="checkbox"> Remember Me</label>
                <a href="#">Forgot Password?</a>
            </div>
            
            <button type="submit" class="btn">Login</button>
            
            <div class="register-link">
                <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register</a></p>
            </div>
        </form>
    </div>
</body>
</html>