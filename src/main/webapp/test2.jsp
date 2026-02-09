<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.dev9.lon.dao.Car"%>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%-- <%@ page import="org.jboss.logging.Logger"%> --%>
<%-- <%@ page import="java.util.logging.Logger" %> --%>
<%@ page import="org.slf4j.Logger"%>
<%@ page import="org.slf4j.LoggerFactory"%>
<%@ page import="com.dev9.lon.sample.ejb.CallBreaker"%>
<%@ page import="com.dev9.lon.sample.ejb.local.*"%>
<%@ page import="com.dev9.lon.sample.ejb.BrokerSBean"%>
<!DOCTYPE html>
<html>
<head>
<title>lon site</title>
</head>
<body>
	<%
	BrokerSBean broker = new BrokerSBean();

	broker.buyStock("AAPL", 10);

	// TODO LOGGER
	// 로거 인스턴스 생성 (클래스 이름이나 식별자 지정 가능)
	// 	Logger logger = Logger.getLogger("MyJspLogger");
	// 	logger.info(" JSP 페이지 실행됨 - INFO 로그");
	// 	logger.debug("디버깅용 메시지 - DEBUG 로그");
	// 	logger.error("에러 발생 시 메시지 - ERROR 로그");

	// 	java.util.logging.Logger julLogger = java.util.logging.Logger.getLogger("JSPLogger");

	org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger("lon--Logger");
	String logName = log.getName();
	log.debug("{} JSP 페이지 - DEBUG 로그 {} {}", "■■■■■■", logName, "■■■■■■");
	log.info("{} JSP 페이지 - INFO 로그 {} {}", "■■■■■■", logName, "■■■■■■");
	log.error("{} JSP 페이지 - ERROR 로그 {} {}", "■■■■■■", logName, "■■■■■■");
	%>

	<%
	System.out.println("lon 디버깅 메시지: JSP 실행됨");
	%>

	<%
	Statement stmt = null;
	Connection conn = null;
	DataSource ds = null;
	Context initCtx = null;
	ResultSet rs = null;

	try {
		System.out.println("jsp에서 EJB 호출 테스트 [성공]");
		InitialContext ctx = new InitialContext();
		// JNDI 이름은 서버 설정에 따라 다름 (예: "java:global/YourApp/CallBreakerBean")
		CallBreaker cb = (CallBreaker) ctx.lookup("java:global/YourApp/CallBreakerBean");
		String result = cb.sayHello("Hello EJB!");
		out.println("EJB 호출 결과: " + result);
	} catch (ClassNotFoundException e) {
		System.out.println("jsp에서 EJB 호출 테스트 [실패]" + e.getMessage());
	}

	try {

		ObjectMapper objectMapper = new ObjectMapper();
		Car car = new Car("yellow", "renault");
		byte[] result = objectMapper.writeValueAsBytes(car);
		System.out.println(" byte[] >>>>>> " + result);
		System.out.println(" toString >>>>>> " + Arrays.toString(result));

		initCtx = new InitialContext();
		ds = (DataSource) initCtx.lookup("java:jboss/datasources/MySqlDS");
		// 		ds = (DataSource) initCtx.lookup("java:/MySqlDS");
		conn = ds.getConnection();

		if (conn != null) {
			out.println("lon 데이터베이스 연결 성공!<br>");
			// 			conn.close();
		} else {
			out.println("lon 데이터베이스 연결 실패.\n");
		}
		stmt = conn.createStatement();

		String sql = "" + "\n " + "\n SELECT ID					"
		+ "\n , post_author, post_date, post_date_gmt, post_content, post_title, post_excerpt, post_status "
		+ "\n , comment_status, ping_status, post_password, post_name, to_ping, pinged					"
		+ "\n , post_modified, post_modified_gmt, post_content_filtered, post_parent, guid, menu_order	"
		+ "\n , post_type, post_mime_type, comment_count				" + "\n FROM wp_posts" + "\n " + "\n ";

		// 		out.println(" SQL >>>> "+sql);
		// 		System.out.println("■■■■■■■■■■■■■■■■■■■■■■■ SQL >>>> "+sql);
		rs = stmt.executeQuery(sql);

		while (rs.next()) {
			out.println("■■■■ lon ID: " + rs.getInt("id") + ", Title: " + rs.getString("menu_order") + "<br/>");
		}
		rs.close();
		stmt.close();
		conn.close();

	} catch (Exception e) {
		e.printStackTrace();
		out.println("■■■■lon 오류 발생: " + e.getMessage());
	} finally {

		out.println(" ■■■■ lon  finally ");
	}
	%>

</body>
</html>