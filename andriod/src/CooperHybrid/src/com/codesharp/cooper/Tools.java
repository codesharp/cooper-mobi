package com.codesharp.cooper;

import java.text.SimpleDateFormat;
import java.util.Date;

import android.R.bool;
import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;

public class Tools {
	//�ж��Ƿ�Ϊ��
	public static Boolean isNullOrEmpty(String value) {
		return value == null || value.equals("") || value.equals("null");
	}

	//�Ƿ���������
	public static Boolean isOnline(Activity activity) {
		if(!isNetworkAvailable(activity)) {
			if(!isWiFiActive(activity)) {
				return false;
			}
		}
		return true;
	}
	//3G����
	public static boolean isNetworkAvailable(Activity activity) {
        ConnectivityManager connectivity = (ConnectivityManager) activity.getSystemService(Context.CONNECTIVITY_SERVICE);
        if (connectivity == null) {
        	return false;
        } else {
        	NetworkInfo info = connectivity.getActiveNetworkInfo();
            if(info == null){
            	return false;
            }else{
                if(info.isAvailable()){
                	return true;
                }
            }
        }
        return false;
    }
	//wifi
	public static boolean isWiFiActive(Activity activity) {
		WifiManager mWifiManager = (WifiManager) activity.getSystemService(Context.WIFI_SERVICE);
         WifiInfo wifiInfo = mWifiManager.getConnectionInfo();
         int ipAddress = wifiInfo == null ? 0 : wifiInfo.getIpAddress();
         if (mWifiManager.isWifiEnabled() && ipAddress != 0) {
             return true;
         } else {
             return false;   
         }
	}
	
	//��������ת������
	public static String toShortDateString(Date date) {
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		return simpleDateFormat.format(date);
	}
}
