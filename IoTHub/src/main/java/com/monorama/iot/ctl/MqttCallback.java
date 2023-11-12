package com.monorama.iot.ctl;

import java.text.SimpleDateFormat;
import java.util.Date;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.jepetto.logger.DisneyLogger;
import org.jepetto.proxy.HomeProxy;

public class MqttCallback implements org.eclipse.paho.client.mqttv3.MqttCallback {

	DisneyLogger cat = new DisneyLogger(MqttCallback.class.getName());
	
	
	
	int count;
	int size = 5;
	//int size = 5;
	String arr[] = new String[size];
	

	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss.SSS");
	Date date = new Date();
	
	String dateString = simpleDateFormat.format(date);
	
	private MqttClient client;
	private HomeProxy proxy;
	
	public MqttCallback(HomeProxy proxy)  {
		this.proxy = proxy;
	}

	public MqttCallback(MqttClient client, HomeProxy proxy) {
		// TODO Auto-generated constructor stub
		this.client = client;
		this.proxy = proxy;
	}

	@Override
	public void connectionLost(Throwable arg0) {
		
	}

	@Override
	public void deliveryComplete(IMqttDeliveryToken arg0) {
	}

	@Override
	public void messageArrived(String topic, MqttMessage msg) 
	{
		String message = null;	
		String serialNum = topic.substring(topic.lastIndexOf("/")+1);
		
		
		try {
			message = msg.toString();
			//cat.debug(raw + "/" + topic );
			System.out.println("topic " + topic + " serialNum " + serialNum + " message " + message );
			MyThread m = new MyThread(client,proxy,message,serialNum);
			m.start();
		} catch (java.lang.NullPointerException e) {
			e.printStackTrace();
			
		} catch (Exception e) {
			e.printStackTrace();
		}

	}


}