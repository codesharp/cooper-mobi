package com.codesharp.cooper.plugins;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.HttpVersion;
import org.apache.http.NameValuePair;
import org.apache.http.auth.AuthScope;
import org.apache.http.client.CookieStore;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.protocol.ClientContext;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.params.ConnManagerPNames;
import org.apache.http.conn.params.ConnPerRouteBean;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.impl.cookie.BasicClientCookie;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.BasicHttpContext;
import org.apache.http.protocol.HttpContext;
import org.apache.http.util.EntityUtils;

import com.codesharp.cooper.Constant;
import com.codesharp.cooper.MainActivity;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.text.format.DateFormat;
import android.util.Log;
import android.webkit.CookieManager;

public class RequestManager {

	private ClientConnectionManager clientConnectionManager;
	private HttpContext context;
	private HttpParams params;
	
	private MainActivity _activity;
	//private SharedPreferences _sharedPrefs;

	public RequestManager(MainActivity activity) 
	{
		this._activity = activity;
		//this._sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this._activity.getApplicationContext());
		this.init();
	}
	
	public static CookieStore cookieStore;
	 
	private void init()
	{
		SchemeRegistry schemeRegistry = new SchemeRegistry();
 
        schemeRegistry.register(new Scheme("http", PlainSocketFactory.getSocketFactory(), 80));
        schemeRegistry.register(new Scheme("https", new EasySSLSocketFactory(), 443));
 
        params = new BasicHttpParams();
        params.setParameter(ConnManagerPNames.MAX_TOTAL_CONNECTIONS, 1);
        params.setParameter(ConnManagerPNames.MAX_CONNECTIONS_PER_ROUTE, new ConnPerRouteBean(1));
        params.setParameter(HttpProtocolParams.USE_EXPECT_CONTINUE, false);
        HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
        HttpProtocolParams.setContentCharset(params, "utf8");
 
        CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
        
//	        credentialsProvider.setCredentials(new AuthScope("cooper.apphb.com", AuthScope.ANY_PORT)
//	        	, new UsernamePasswordCredentials("UserNameHere", "UserPasswordHere"));
        clientConnectionManager = new ThreadSafeClientConnManager(params, schemeRegistry);
 
        context = new BasicHttpContext();
        context.setAttribute("http.auth.credentials-provider", credentialsProvider);
	}
	
	public DefaultHttpClient getHttpClient()
	{
		
		DefaultHttpClient httpClient = new DefaultHttpClient(clientConnectionManager, params);
		
		SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this._activity.getApplicationContext());
		String cookieValue = sharedPrefs.getString(Constant.DOMAIN, "");
		HttpContext localContext = null;
		if(cookieValue != "")
		{
			String[] sets = cookieValue.split(";");
	
			BasicCookieStore cookieStore = new BasicCookieStore();
			BasicClientCookie cookie = new BasicClientCookie("cooper", null);
			cookie.setValue(sets[1]);
			cookie.setDomain(sets[2]);
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			try {
				cookie.setExpiryDate(format.parse(sets[3]));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			cookie.setPath(sets[4]);
			cookie.setComment(sets[5]);
			cookie.setSecure(false);
			cookie.setVersion(Integer.parseInt(sets[7]));
			cookieStore.addCookie(cookie);
			
	        httpClient.setCookieStore(cookieStore);
	        localContext = new BasicHttpContext();
            localContext.setAttribute(ClientContext.COOKIE_STORE, cookieStore);
		}
    	
        return httpClient;
	}
}
