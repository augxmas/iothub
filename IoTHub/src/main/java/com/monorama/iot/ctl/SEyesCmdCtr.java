package com.monorama.iot.ctl;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;
import org.jepetto.proxy.HomeProxy;
import org.jepetto.util.PropertyReader;

/**
 * Servlet implementation class SEyesCmdCtr
 */
@WebServlet("/seyescmdctr")
public class SEyesCmdCtr extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SEyesCmdCtr() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    static PropertyReader reader = PropertyReader.getInstance();
    public final String MQTT_BROKER_IP = reader.getProperty("mqtt_ip"); //"tcp://iot.seyes.kr:80";
    MqttClient client = null; 
    
    public void init() {
		try {
			HomeProxy proxy = HomeProxy.getInstance();
			InetAddress addr;
			try {
				addr = InetAddress.getLocalHost();
				
				client = new MqttClient(MQTT_BROKER_IP,	MqttClient.generateClientId(),	new MemoryPersistence());
				
				client.connect();
				
				//client.subscribe("Safe-Home/ack/#", 1); 
				client.setCallback(new MqttCallback(proxy)); //
			} catch (UnknownHostException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
			
		}
		catch (MqttException e) {
			e.printStackTrace();
		}
		catch(Exception e) {
			e.printStackTrace();
		}		
    }
    

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doIt(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doIt(request, response);
	}
	
	private static String cmd01 = "cmd01";
	private static String cmd02 = "cmd02";
	private static String cmd03 = "cmd03";
	private static String cmd04 = "cmd04";
	private static String cmd05 = "cmd05";
	private static String cmd06 = "cmd06";
	private static String cmd07 = "cmd07";
	private static String cmd08 = "cmd08";

	private static String cmd11 = "cmd11";
	private static String cmd12 = "cmd12";
	private static String cmd13 = "cmd13";
	private static String cmd14 = "cmd14";
	private static String cmd15 = "cmd15";
	private static String cmd16 = "cmd16";
	private static String cmd17 = "cmd17";
	private static String cmd18 = "cmd18";
	
	
	private void doIt(HttpServletRequest req, HttpServletResponse res) {
		
		String _cmd01 = (String)req.getAttribute(cmd01) == null ? "0" : "1";
		String _cmd02 = (String)req.getAttribute(cmd02) == null ? "0" : "1";
		String _cmd03 = (String)req.getAttribute(cmd03) == null ? "0" : "1";
		String _cmd04 = (String)req.getAttribute(cmd04) == null ? "0" : "1";
		String _cmd05 = (String)req.getAttribute(cmd05) == null ? "0" : "1";
		String _cmd06 = (String)req.getAttribute(cmd06) == null ? "0" : "1";
		String _cmd07 = (String)req.getAttribute(cmd07) == null ? "0" : "1";
		String _cmd08 = (String)req.getAttribute(cmd08) == null ? "0" : "1";
		
		String _cmd11 = (String)req.getAttribute(cmd11) == null ? "0" : "1";
		String _cmd12 = (String)req.getAttribute(cmd12) == null ? "0" : "1";
		String _cmd13 = (String)req.getAttribute(cmd13) == null ? "0" : "1";
		String _cmd14 = (String)req.getAttribute(cmd14) == null ? "0" : "1";
		String _cmd15 = (String)req.getAttribute(cmd15) == null ? "0" : "1";
		String _cmd16 = (String)req.getAttribute(cmd16) == null ? "0" : "1";
		String _cmd17 = (String)req.getAttribute(cmd17) == null ? "0" : "1";
		String _cmd18 = (String)req.getAttribute(cmd18) == null ? "0" : "1";
		
		String serialNum  = (String)req.getAttribute(IoTListener.serialNumField);
		
		String topic		= null;
		try {
			//client.subscribe("Fire/ack/#", 1);
			MqttMessage msg = new MqttMessage();
			topic = getTopic("");
			client.publish(topic, msg);
			
		} catch (MqttException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
	
	private String getTopic(String str) {
		String topic = "Fire/ack/#";
		return topic;
	}

}
