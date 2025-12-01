# Hướng dẫn fix lỗi Eclipse cho Music Management

## Lỗi hiện tại

Eclipse báo lỗi:
- `cannot find symbol: class HttpServlet`
- `package javax.servlet does not exist`
- `':' expected` tại mode-switcher.js line 56

## Nguyên nhân

1. **ProfileController.java**: Thiếu thư viện `servlet-api.jar` trong Eclipse build path
2. **mode-switcher.js**: Eclipse báo SAI - không có lỗi thực sự

## Cách fix

### 1. Thêm Servlet API vào Eclipse Build Path

#### Cách 1: Dùng Tomcat Runtime (Khuyến nghị)
1. Chuột phải project → **Properties**
2. Chọn **Targeted Runtimes**
3. Check vào **Apache Tomcat v9.0** (hoặc version bạn đang dùng)
4. Click **Apply and Close**

#### Cách 2: Thêm JAR thủ công
1. Download `servlet-api.jar` từ Tomcat:
   - Vào thư mục cài đặt Tomcat (ví dụ: `C:\Program Files\Apache Software Foundation\Tomcat 9.0`)
   - Copy file `lib/servlet-api.jar`
   
2. Thêm vào project:
   - Chuột phải project → **Build Path** → **Configure Build Path**
   - Tab **Libraries** → **Add External JARs**
   - Chọn file `servlet-api.jar` vừa copy
   - Click **Apply and Close**

### 2. Fix lỗi JavaScript giả (mode-switcher.js)

Eclipse đôi khi báo lỗi sai với template literals ES6. Bỏ qua lỗi này.

Nếu muốn tắt cảnh báo:
1. **Window** → **Preferences**
2. **JavaScript** → **Validator**
3. Uncheck **Enable JavaScript semantic validation**
4. Click **Apply and Close**

## Xác nhận fix thành công

Sau khi thêm servlet-api.jar:
- Tất cả lỗi `cannot find symbol` trong ProfileController sẽ biến mất
- Project sẽ compile thành công
- Có thể deploy lên Tomcat bình thường

## File đã được sửa

✅ **ProfileController.java**:
- Sửa method upload avatar: dùng `FileUploadUtil.save()` thay vì `getFileName()` và `saveFile()`
- Thêm bio vào SQL UPDATE
- Xóa unused import `UserBO`
- Thay `printStackTrace()` bằng `System.err.println()`

✅ **UserDAO.java**:
- Thêm load `avatar` và `bio` trong method `map()`

✅ **mode-switcher.js**: Không có lỗi

✅ **playlist-manager.js**: Không có lỗi

## Lưu ý quan trọng

⚠️ **KHÔNG** copy `servlet-api.jar` vào `WEB-INF/lib` vì:
- Tomcat đã có sẵn servlet-api
- Copy vào sẽ gây xung đột class loader
- Chỉ thêm vào Eclipse build path để compile

## Kiểm tra sau khi fix

```bash
# Trong Eclipse: Chuột phải project
Project → Clean...
Project → Build Project

# Build thành công → Deploy lên Tomcat
```

Nếu vẫn gặp lỗi, restart Eclipse và rebuild lại project.
