/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.auth;

import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.common.collect.Lists;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author user
 */
public class CredentialAuth {

List<String> scopes = Lists.newArrayList("https://www.googleapis.com/auth/youtube.force-ssl");

    public com.google.api.client.auth.oauth2.Credential getCredential(int port,String clientId, String clientSecret, String refreshToken)
    {
        try
        {        
        //com.google.api.client.auth.oauth2.Credential credential = Auth.authorize(scopes, "commentthreads",port);
        com.google.api.client.auth.oauth2.Credential credential = Auth.getCredentials(clientId, clientSecret, refreshToken);
        System.out.println("credential "+credential);
        return credential;
        } 
        catch (GoogleJsonResponseException e) 
        {
            
            System.err.println("GoogleJsonResponseException code: " + e.getDetails().getCode()
                    + " : " + e.getDetails().getMessage());
            e.printStackTrace();

        } 
        catch (IOException e) 
        {
            System.err.println("IOException: " + e.getMessage());
            e.printStackTrace();
        } 
        catch (Throwable t) 
        {
            System.err.println("Throwable: " + t.getMessage());
            t.printStackTrace();
        }     
    return null;
    }
}
