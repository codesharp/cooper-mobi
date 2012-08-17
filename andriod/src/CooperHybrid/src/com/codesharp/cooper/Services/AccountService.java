package com.codesharp.cooper.Services;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import com.codesharp.cooper.Constant;
import com.codesharp.cooper.MainActivity;
import com.codesharp.cooper.plugins.RequestManager;

public class AccountService {

	private MainActivity _activity;
	private DefaultHttpClient _httpClient;
	
	public DefaultHttpClient getHttpClient() {
		return this._httpClient;
	}
	
	public AccountService(MainActivity activity)
	{
		this._activity = activity;
		
		RequestManager requestManager = new RequestManager(this._activity);
		this._httpClient = requestManager.getHttpClient();
	}

	//µÇÂ¼
	public HttpResponse login(String username, String password) throws ClientProtocolException, IOException {
		
		HttpPost request = new HttpPost(Constant.LOGIN_URL);
		List<NameValuePair> postParameters = new ArrayList<NameValuePair>();
		postParameters.add(new BasicNameValuePair("userName", username));
		postParameters.add(new BasicNameValuePair("password", password));
		try {
			UrlEncodedFormEntity formEntity = new UrlEncodedFormEntity(postParameters);
			request.setEntity(formEntity);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		request.addHeader("X-Requested-With", "xmlhttp");
		
		HttpResponse response = this._httpClient.execute(request);		
		return response;
	}
	//×¢Ïú
	public HttpResponse logout() throws ClientProtocolException, IOException {
		HttpPost request = new HttpPost(Constant.LOGOUT_URL);
		HttpResponse response = this._httpClient.execute(request);
		return response;
	}
	
}
