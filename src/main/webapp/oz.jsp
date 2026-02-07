<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>이미지 붙여넣기 저장</title>
</head>
<body>
  <h2>화면 캡쳐 붙여넣기 테스트</h2>
  <div id="dropzone" style="border:2px dashed #aaa; padding:20px;">
    여기에 Ctrl+V로 이미지를 붙여넣어 보세요
  </div>
  <img alt="미리보기" id="preview" style="max-width:400px; margin-top:20px;" />

  <script>
    document.addEventListener("paste", function(event) {
      const items = event.clipboardData.items;
      for (let i = 0; i < items.length; i++) {
        if (items[i].type.indexOf("image") !== -1) {
          const file = items[i].getAsFile();
          const url = URL.createObjectURL(file);

          // 화면에 표시
          document.getElementById("preview").src = url;

          // 서버로 업로드 (예: fetch 사용)
          const formData = new FormData();
          formData.append("file", file);

          fetch("/upload", {
            method: "POST",
            body: formData
          }).then(res => console.log("업로드 완료"));
        }
      }
    });
  </script>




    <div id="ozviewer"></div>








</body>
</html>
