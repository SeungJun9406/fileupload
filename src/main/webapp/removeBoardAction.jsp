<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>

<%
	// 저장 위치
	String dir = request.getServletContext().getRealPath("/upload");
	// 파일 크기
	int max = 10 * 1024 * 1024;
	// 멀티파트 값 가져오기
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	//System.out.println(mRequest.getOriginalFileName("boardFile") + " <- boardFile");
	// 유효성 검사
	if (mRequest.getParameter("boardNo") == null){
		response.sendRedirect(request.getContextPath() + "/boardList.jsp");
		return;
	}
	
	int boardNo = Integer.parseInt(mRequest.getParameter("boardNo"));
	String saveFilename = mRequest.getParameter("saveFilename");
	
	// 파일 삭제
	
	File f = new File(dir + "/" + saveFilename);
	if (f.exists()){
		f.delete();
		System.out.println(saveFilename + "파일삭제");
	}
	
	// sql 보드 삭제
	String driver = "org.mariadb.jdbc.Driver";
	String dbUrl= "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbUser = "root";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	
	String delBoardSql = "DELETE FROM board WHERE board_no = ?";
    PreparedStatement delBoardStmt = conn.prepareStatement(delBoardSql);
    delBoardStmt.setInt(1, boardNo);
	System.out.println(delBoardStmt + "<--- removeBoardAction delBoardStmt");
	
    int delRow = delBoardStmt.executeUpdate();
    
    if(delRow == 1) {
    	System.out.println("삭제완료");
    	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
    } else {
    	System.out.println("삭제실패");
    }
%>