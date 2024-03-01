package com.monorama.iot.ctl;

import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.jepetto.bean.Facade;
import org.jepetto.proxy.HomeProxy;
import org.jepetto.util.PropertyReader;

public class MyThread extends Thread {



	static PropertyReader reader = PropertyReader.getInstance();
	private Logger logger = LogManager.getLogger(MyThread.class);
	//final String MQTT_BROKER_IP = reader.getProperty("mqtt_ip"); // "tcp://iot.seyes.kr:80";
	private static final String dataSource = reader.getProperty("iot_mysql_datasource");
	private static final String QUERY_FILE = reader.getProperty("iot_query_file");
	private static final String hexdata = "0x";

	private HomeProxy proxy = null;
	//private MqttClient client = null;

	private String raw;
	private String serialNum;

	public MyThread(MqttClient client, HomeProxy proxy, String raw, String serialNum) {
		// TODO Auto-generated constructor stub
		//this.client = client;
		this.proxy = proxy;
		this.raw = raw;
		this.serialNum = serialNum;
	}

	@Override
	public void run() {

		int updatedCnt = -1;
		//Map<String, String> dummy = new HashMap<String, String>();
		
		try {

			Facade remote = proxy.getFacade();
			//String unixDate = null;

			String isFired1st = null;
			String isFired2nd = null;
			//String selectedDate = null;

			String args[] = null; // new String[12];

			// int idx = 0;

			//raw = this.args;
			String _unixDate	= raw.substring(0, 8); // unixTime (8)
			String unixDate		= getTimestampToDate(_unixDate);
			String unixTime		= getTimestampToTime(_unixDate);
			isFired1st			= raw.substring(8, 9);
			isFired2nd			= raw.substring(9, 10);
			System.out.println("isFired1st " + isFired1st);
			System.out.println("isFired2nd " + isFired2nd);
			Map<String, String> map = new HashMap<String, String>();
			if (isFired1st.equals("1") || isFired2nd.equals("1")) {
				args = new String[] { serialNum, unixDate+unixTime, isFired1st, isFired2nd, };
				updatedCnt = remote.executeUpdate(dataSource, QUERY_FILE, IoTListener.c_sensor, map, args);
				if (updatedCnt > 0) {
					System.out.println(updatedCnt + " updated...");
				}
			}

			if (isFired1st.equals("1") && isFired2nd.equals("1")) {
				args = new String[] { serialNum, unixDate, isFired1st, isFired2nd, };
				updatedCnt = remote.executeUpdate(dataSource, QUERY_FILE, IoTListener.c_sensor, map, args);

			}

		} catch (java.lang.StringIndexOutOfBoundsException e) {
			e.printStackTrace();
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (ArrayIndexOutOfBoundsException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// logger.info(updatedCnt + "updated count ");
		}//*/
	}

	private static String getTimestampToDate(String unixTime) {
		String hex1 = hexdata + unixTime;
		int covertedValue = Integer.decode(hex1);
		Date date = new java.util.Date(covertedValue * 1000L);
		SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
		sdf.setTimeZone(java.util.TimeZone.getTimeZone("GMT+9"));
		String formattedDate = sdf.format(date);
		return formattedDate;
	}

	private static String getTimestampToTime(String unixTime) {
		String hex1 = hexdata + unixTime;
		int covertedValue = Integer.decode(hex1);
		Date date = new java.util.Date(covertedValue * 1000L);
		SimpleDateFormat sdf = new java.text.SimpleDateFormat("HHmmss");
		sdf.setTimeZone(java.util.TimeZone.getTimeZone("GMT+9"));
		String formattedDate = sdf.format(date);
		return formattedDate;
	}

	public static String get(String str) {
		String hex = hexdata + str;
		int covertedValue = Integer.decode(hex);
		String data = String.valueOf(covertedValue);
		return data;
	}

}