package com.monorama.iot.ctl;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.time.Instant;
import java.util.Calendar;
import java.util.Date;

import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence;

public class Test {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		
		Calendar cal = null; //Calendar.getInstance();
		long unixTimestamp =  Instant.now().getEpochSecond();
		System.out.println(unixTimestamp);
		//System.out.println(Long.toHexString(unixTimestamp));
		//System.out.println("---------------------------------------");

		String unixTime = null; //String.valueOf(Long.toHexString(Instant.now().getEpochSecond()));
		
		InetAddress addr;
		try {
			addr = InetAddress.getLocalHost();
			MqttClient client = null;
			try {
				client = new MqttClient("tcp://mqtt.seyes.kr:80",	MqttClient.generateClientId(),	new MemoryPersistence());
				client.connect();
				System.out.println("connected.......");
				//client.subscribe("Fire/ack/#", 1);
				//client.subscribe("Safe-Home/ack/#", 1); 
				//client.setCallback(new MqttCallback(null)); //
			} catch (MqttException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			String topic = "Fire/ack/F008D14CF858";
			String _topic = "Fire/req/F008D14CF858";
			MqttMessage msg = new MqttMessage();
			
			
			
			while(true) {
				/*
				try {
					Thread.sleep(1000);
					//Fire/ack/
					unixTime = String.valueOf(Long.toHexString(Instant.now().getEpochSecond()));
					msg.setPayload((unixTime+"00"+"FF").getBytes());
					client.publish(topic, msg);
					System.out.println("sending....." + unixTime);
				} catch (InterruptedException | MqttException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}//*/
				
				/*
				try {
					Thread.sleep(1000);
					//Fire/ack/
					unixTime = String.valueOf(Long.toHexString(Instant.now().getEpochSecond()));
					long current = System.currentTimeMillis();
					if(current%3 == 0) {
						msg.setPayload((unixTime+"00000000FF").getBytes());
					}else if(current%3 == 1) {
						msg.setPayload((unixTime+"00000000FF").getBytes());
					}else if(current%3 == 2) {
						msg.setPayload((unixTime+"00000000FF").getBytes());
					}
					client.publish(_topic, msg);
					System.out.println("sending....." + unixTime);
				} catch (InterruptedException | MqttException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}//*/
				
			}
			
			

		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		
		

	}

}
