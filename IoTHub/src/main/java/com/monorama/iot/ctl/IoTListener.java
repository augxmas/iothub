package com.monorama.iot.ctl;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Instant;
import java.util.Calendar;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import javax.naming.NamingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.MqttPersistenceException;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.jdom2.Document;
import org.jdom2.JDOMException;
import org.jepetto.bean.Facade;
import org.jepetto.logger.DisneyLogger;
import org.jepetto.proxy.HomeProxy;
import org.jepetto.sql.XmlConnection;
import org.jepetto.util.PropertyReader;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class IoTListener extends HttpServlet {

	DisneyLogger cat = new DisneyLogger(IoTListener.class.getName());

	public static final String apts = "APTS";

	private static final long serialVersionUID = 1L;

	static PropertyReader reader = PropertyReader.getInstance();

	public static final String MQTT_BROKER_IP	= reader.getProperty("mqtt_ip"); // "tcp://iot.seyes.kr:80";
	public static final String dataSource		= reader.getProperty("iot_mysql_datasource");
	public static final String QUERY_FILE		= reader.getProperty("iot_query_file");

	public static final String mode 	= "mode";
	public static final String on		= "on";
	public static final String off		= "off";
	public static final String CRC		= "FF";
	public static final String onValue	= "1";

	public static final String xpath		= "//recordset/row";
	public static final String topic4sub	= "Fire/ack/#";
	public static final String topic4pub	= "Fire/req/";

	public static final String loginMode	= "1";	// 로그인
	public static final String cmdMode		= "2";	// 화재기 제어
	public static final String stateMode	= "3";	// 관리건물의 화재 상태
	public static final String logoutMode	= "5";	// 로그아웃
	public static final String statusMode	= "4";	// 화재 발생 및 제언 통계

	public static final String r_member	= "r_member";
	public static final String u_sensor = "u_sensor";
	public static final String c_sensor = "c_sensor";
	public static final String r_state	= "r_state";
	public static final String r_status	= "r_status";

	public static final String regdateField		= "regdate";
	public static final String _regdateField		= "_regdate";
	public static final String aptNameField		= "aptName";
	public static final String passwordField	= "password";
	public static final String idField 			= "id";
	public static final String nameField		= "name";
	public static final String serialNumField	= "serialNum";
	public static final String idxField			= "idx";
	public static final String cntField			= "cnt";

	public static final String CODE					= "code";
	public static final String ISFIRED00			= "isFired00";
	public static final String ISFIRED01			= "isFired01";
	public static final String MESSAGE				= "message";
	public static final String VALUE4NORMAL			= "200";
	public static final String VALUE4NOTFOUND		= "400";
	public static final String VALUE4INTERNALERROR	= "500";
	
	
	public static final String CMD01 = "cmd01";
	public static final String CMD02 = "cmd02";
	public static final String CMD03 = "cmd03";
	public static final String CMD04 = "cmd04";
	public static final String CMD05 = "cmd05";
	public static final String CMD06 = "cmd06";
	public static final String CMD07 = "cmd07";
	public static final String CMD08 = "cmd08";

	public static final String CONTENTTYPE = "application/json;charset=utf-8";

	public IoTListener() {
		super();
	}

	public static MqttClient client = null;

	public void init() {
		try {
			HomeProxy proxy = HomeProxy.getInstance();
			client = new MqttClient(MQTT_BROKER_IP, MqttClient.generateClientId(), new MemoryPersistence());
			client.connect();
			client.subscribe(topic4sub, 1);
			client.setCallback(new MqttCallback(proxy)); //
			
		} catch (MqttException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected void doIt(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

		HomeProxy proxy = HomeProxy.getInstance();
		Facade remote = proxy.getFacade();
		PrintWriter out = null;
		HashMap<String, String> map = new HashMap<String, String>();
		HashMap<String, String> dummy = new HashMap<String, String>();
		Document doc = null;
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rset = null;
		String args[] = null;
		String _mode = (String) req.getAttribute(mode);
		Map<String, String> msg = new LinkedHashMap<String, String>();
		JSONArray arr = new JSONArray();

		try {
			// 화재 제어(controll)
			if (_mode.equalsIgnoreCase(cmdMode)) {
				String cmd01 = (String) req.getAttribute(CMD01);	//벨소리끄기
				String cmd02 = (String) req.getAttribute(CMD02);	//시각경보끄기
				String cmd03 = (String) req.getAttribute(CMD03);	//비상방송끄기
				String cmd04 = (String) req.getAttribute(CMD04);	//펌프#1 끄기
				String cmd05 = (String) req.getAttribute(CMD05);	//펌프#2 끄기
				String cmd06 = (String) req.getAttribute(CMD06);	//펌프#3 끄기
				String cmd07 = (String) req.getAttribute(CMD07);	//펌프#4 끄기
				String cmd08 = (String) req.getAttribute(CMD08);	//펌프#5 끄기
				String serialNum = (String) req.getAttribute(IoTListener.serialNumField);
				String cmd = cmd01 + cmd02 + cmd03 + cmd04 + cmd05 + cmd06 + cmd07 + cmd08;

				try {
					args = new String[] { cmd01, cmd02, cmd03, cmd04, cmd05, cmd06, cmd07, cmd08, serialNum };
					remote.executeUpdate(dataSource, QUERY_FILE, u_sensor, dummy, args);
					publish(serialNum, cmd);

					msg.put(CODE, VALUE4NORMAL);
					msg.put(MESSAGE, 	"화재 제어 신호 정상 접수");
					msg.put("bell",		cmd01.equals(onValue) ? on : off);
					msg.put("sight",	cmd02.equals(onValue) ? on : off);
					msg.put("sound",	cmd03.equals(onValue) ? on : off);
					msg.put("pump1",	cmd04.equals(onValue) ? on : off);
					msg.put("pump2",	cmd05.equals(onValue) ? on : off);
					msg.put("pump3",	cmd06.equals(onValue) ? on : off);
					msg.put("pump4",	cmd07.equals(onValue) ? on : off);
					msg.put("pump5",	cmd08.equals(onValue) ? on : off);

				} catch (MqttPersistenceException e) {
					msg.put(CODE, VALUE4INTERNALERROR);
					msg.put(MESSAGE, e.getMessage());
					e.printStackTrace();
				} catch (MqttException e) {
					msg.put(CODE, VALUE4INTERNALERROR);
					msg.put(MESSAGE, e.getMessage());
					e.printStackTrace();
				} catch (SQLException e) {
					msg.put(CODE, VALUE4INTERNALERROR);
					msg.put(MESSAGE, e.getMessage());
					e.printStackTrace();
				} catch (NamingException e) {
					msg.put(CODE, VALUE4INTERNALERROR);
					msg.put(MESSAGE, e.getMessage());
					e.printStackTrace();
				} catch (JDOMException e) {
					msg.put(CODE, VALUE4INTERNALERROR);
					msg.put(MESSAGE, e.getMessage());
					e.printStackTrace();
				} finally {
					JSONObject json = new JSONObject(msg);
					res.setContentType(CONTENTTYPE);
					out = res.getWriter();
					out.println(json.toJSONString());
				}
			} // end of c_sensor(화재 제어)

			// 사용자 로그인
			else if (_mode.equalsIgnoreCase(loginMode)) {
				String id = (String) req.getAttribute(idField);
				String password = (String) req.getAttribute(passwordField);
				String _id = null;
				String _password = null;
				String name = null;
				String serialNum = null;
				String aptName = null;
				args = new String[] { id, password };

				try {
					doc = remote.executeQuery(dataSource, QUERY_FILE, r_member, dummy, args);
					con = new XmlConnection(doc);
					stmt = con.prepareStatement(xpath);
					rset = stmt.executeQuery();
					HttpSession session = req.getSession(true);
					if (rset.next()) {
						_id = rset.getString(idField);
						_password = rset.getString(passwordField);
						name = rset.getString(nameField);
						serialNum = rset.getString(serialNumField);
						aptName = rset.getString(aptNameField);
						
						session.setAttribute(idField,_id);
						session.setAttribute(nameField, name);
						session.setAttribute(serialNumField, serialNum);
						session.setAttribute(aptNameField, aptName);

						if (id.equals(_id) && password.equals(_password)) {
							res.sendRedirect("/iothub/home.jsp");
						}
					} else {
						msg.put(CODE, VALUE4NOTFOUND);
						msg.put(MESSAGE, "입력정보를 확인해주세요");
						res.sendRedirect("/iothub/pages-login.jsp?code=400");
					}
				} catch (SQLException | NamingException | JDOMException | IOException e) {
					e.printStackTrace();
				} finally {
					JSONObject json = new JSONObject(msg);
					res.setContentType(CONTENTTYPE);
					out = res.getWriter();					
				}
			} // end of loginMode(사용자 로그인)
			
			// 담당 apt의 화재 발생 여부
			else if (_mode.equalsIgnoreCase(stateMode)) {

				HttpSession session = req.getSession(true);
				String id = (String)session.getAttribute(idField);
				args = new String[] { id };
				
				try {
					doc = remote.executeQuery(dataSource, QUERY_FILE, r_state, dummy, args);
					con = new XmlConnection(doc);
					stmt = con.prepareStatement(xpath);
					rset = stmt.executeQuery();
					JSONObject json = null;
					boolean isFiredFound = false;
					int index = 0;
					while (rset.next()) {
						msg		= new LinkedHashMap<String, String>();
						json	= new JSONObject();
						//msg.put(idxField,		rset.getString(idxField));
						msg.put(aptNameField,	rset.getString(aptNameField));
						msg.put(ISFIRED00,		rset.getString(ISFIRED00));
						msg.put(ISFIRED01,		rset.getString(ISFIRED01));
						msg.put(regdateField,	rset.getString(regdateField));
						msg.put(_regdateField,	rset.getString(_regdateField));
						msg.put(serialNumField,	rset.getString(serialNumField));
						msg.put(CODE, VALUE4NORMAL);
						json.putAll(msg);
						arr.add(index, json);
						isFiredFound = true;
						index++;
					}
					
					if(isFiredFound) {
						res.setContentType(CONTENTTYPE);
						out = res.getWriter();
						out.println(arr.toJSONString());
					}
					else {
						msg.put(CODE, VALUE4NOTFOUND);
						msg.put(MESSAGE, "현재 건물은 안전하게 관리되고 있습니다.");
						json = new JSONObject(msg);
						res.setContentType(CONTENTTYPE);
						out = res.getWriter();
						out.println(arr.toJSONString());
					}
					
				} catch (SQLException | NamingException | JDOMException | IOException e) {
					e.printStackTrace();
				} finally {

				}
			} // end of r_state (담당 apt의 화재 발생 여부)
			
			else if (_mode.equalsIgnoreCase(statusMode)) {

				HttpSession session = req.getSession(true);
				String id = (String)session.getAttribute(idField);
				Calendar cal = Calendar.getInstance();
				int year = cal.get(Calendar.YEAR);
				int _month = cal.get(Calendar.MONTH)+1;
				String month = String.valueOf(_month);
				if(_month < 10) {
					month = "0"+_month;
				}
				args = new String[] {id,id,year+month+"%",id,year+month+"%"};
				
				try {
					doc = remote.executeQuery(dataSource, QUERY_FILE, r_status, dummy, args);
					con = new XmlConnection(doc);
					stmt = con.prepareStatement(xpath);
					rset = stmt.executeQuery();
					JSONObject json = null;
					boolean isFiredFound = false;
					int index = 0;
					while (rset.next()) {
						msg		= new LinkedHashMap<String, String>();
						json	= new JSONObject();
						msg.put(idxField,		rset.getString(idxField));
						msg.put(aptNameField,	rset.getString(aptNameField));
						msg.put(serialNumField,	rset.getString(serialNumField));
						msg.put(cntField,	rset.getString(cntField));
						msg.put(CODE, VALUE4NORMAL);
						json.putAll(msg);
						arr.add(index, json);
						isFiredFound = true;
						index++;
					}
					
					if(isFiredFound) {
						res.setContentType(CONTENTTYPE);
						out = res.getWriter();
						out.println(arr.toJSONString());
					}
					else {
						msg.put(CODE, VALUE4NOTFOUND);
						msg.put(MESSAGE, "현재 건물은 안전하게 관리되고 있습니다.");
						json = new JSONObject(msg);
						res.setContentType(CONTENTTYPE);
						out = res.getWriter();
						out.println(arr.toJSONString());
					}
					
				} catch (SQLException | NamingException | JDOMException | IOException e) {
					e.printStackTrace();
				} finally {

				}
				
				
			}
			
			// 로그아웃
			else if (_mode.equalsIgnoreCase(logoutMode)) {
				HttpSession session = req.getSession(true);
				session.invalidate();
				res.sendRedirect("/iothub/pages-login.jsp");
			} // end of logout

		} catch (java.lang.NullPointerException e) {
			System.out.println("Started............Listener");
		}

	}

	public static void publish(String serialNum, String cmd) throws MqttPersistenceException, MqttException {
		String topic = topic4pub + serialNum;
		MqttMessage msg = new MqttMessage();
		String unixTime = String.valueOf(Long.toHexString(Instant.now().getEpochSecond()));
		System.out.println(topic + unixTime + cmd + "FF");
		msg.setPayload((unixTime + cmd + CRC).getBytes());
		client.publish(topic, msg);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doIt(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doIt(request, response);
	}

}
