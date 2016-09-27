package youtube.auth;

import com.google.api.client.auth.oauth2.AuthorizationCodeRequestUrl;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.auth.oauth2.StoredCredential;
import com.google.api.client.auth.oauth2.TokenResponse;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.store.DataStore;
import com.google.api.client.util.store.FileDataStoreFactory;

import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.List;

/**
 * 
 * Cette Class est utilise par toutes les autres classes 
 * pour l'autourisation et l'authentification
 * 
 * @author Saber NOUIOUA
 */
public class Auth {

    /**
     * Declaration d'une instance de HTTP transport.
     */
    public static final HttpTransport http_transport = new NetHttpTransport();

    /**
     * Definition d'une instance de JSON factory.
     */
    public static final JsonFactory json_factory = new JacksonFactory();

    /**
     * Ceci est le répertoire qui sera utilisé dans le dossier personnel de l'utilisateur 
     * où les jetons OAuth seront stockés.
     */
    private static final String credential_directory = ".oauth-credentials";

    /**
     * autoriser les utilisateurs à acceder aux données
     *
     * @param scopes              liste des scopes nécessaires pour executer youtube
     * @param credentialDatastore nom de la Datastore des credentials pour mettre en cache des jetons OAuth
     * @port  le port de local server
     * @return 
     * @throws java.io.IOException
     */
    
    public static Credential authorize(List<String> scopes, String credentialDatastore,int port) throws IOException {

        /**
         * Recuperer la clé secrète à partir du fichier "client_secrets.json"
        */   
        
        Reader clientSecretReader         = new InputStreamReader(Auth.class.getResourceAsStream("/resources/client_secrets.json"));
        GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(json_factory, clientSecretReader);
        
        /**
         * Verification de la clé (Default = "Enter X here").
         */        
        
        if (
            clientSecrets.getDetails().getClientId().startsWith("Enter")    || 
            clientSecrets.getDetails().getClientSecret().startsWith("Enter")
           ) 
        {
            System.out.println("Saisir la clé secret à aprtir de https://console.developers.google.com/project/_/apiui/credential "
                               +"dans le fichier client_secrets.json");
            System.exit(1);
        }        
        /**
         * Cretation de credential dans ~/.oauth-credentials/${credentialDatastore}
        */     
        //System.out.println("chemin vers credential "+System.getProperty("user.home") + "/" + credential_directory);
        
        FileDataStoreFactory fileDataStoreFactory = new FileDataStoreFactory(new File(System.getProperty("user.home") + "/" + credential_directory));
        DataStore<StoredCredential> datastore     = fileDataStoreFactory.getDataStore(credentialDatastore);
        
        //System.out.println("ID  "+datastore.getId());
        
        GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder
        (
        http_transport, json_factory, clientSecrets, scopes
        ).setCredentialDataStore(datastore)
         .setAccessType("offline")
         .build(); 
        
        //System.out.println("FLOW "+flow.getAccessType());
        /**
         * Construire le serveur local et le lier au port 8080         
        */
        //System.out.println("youtube.auth.Auth.authorize()  "+port);
        
        LocalServerReceiver localReceiver = new LocalServerReceiver.Builder().setPort(port).build();    
        
        //System.out.println("HOST "+localReceiver.getHost()+" PORT "+localReceiver.getPort()+" URL "+localReceiver.getRedirectUri());
        
        // Autorisation
        //System.out.println("ACCESS TOKENS "+new AuthorizationCodeInstalledApp(flow, localReceiver).authorize("user"));
        //                
        //
        return new AuthorizationCodeInstalledApp(flow, localReceiver).authorize("user");
    }
    
public static Credential authorize(String userId,GoogleAuthorizationCodeFlow flow,LocalServerReceiver receiver) throws IOException {
    try {
        Credential credential = flow.loadCredential(userId);

        if (credential != null
                && (credential.getRefreshToken() != null || credential.getExpiresInSeconds() > 60)) {

            return credential;
        }
        // open in browser
        String redirectUri = null;
        try {
            redirectUri = receiver.getRedirectUri();
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        AuthorizationCodeRequestUrl authorizationUrl = flow.newAuthorizationUrl()
                .setRedirectUri(redirectUri);
        //onAuthorization(authorizationUrl);
        // receive authorization code and exchange it for an access token
        String code = receiver.waitForCode();
        TokenResponse response = flow.newTokenRequest(code).setRedirectUri(redirectUri)
                .execute();
        // store credential and return it

        Credential c = flow.createAndStoreCredential(response, userId);

        return c;
    } finally {
        try {

            receiver.stop();
        } catch (Exception e) {
            //LOG.error(e.toString());
            System.out.println(e.toString());

        }
    }
}

public static Credential getCredentials(String clientId, String clientSecret, String refreshToken) throws IOException {
  //String clientId = "650879593345-6adu3sbc33l4tpu58p3l8q1q59fnjm2i.apps.googleusercontent.com";
  //String clientSecret = "mIHV54g5RvR8e9pjYnyvyOgJ";
  //String refreshToken = "1/gWjY-BwotB9pGMNf-XIx52cgak8LU6pYcK285AI1ZGY";
  //String refreshToken = "1/RjF3AoxZ5EkHOflBaOear1adpULQ1-iZ88sjKsY3nUU";
  return new GoogleCredential.Builder()
      .setJsonFactory(json_factory)
      .setTransport(http_transport)
      .setClientSecrets(clientId, clientSecret)      
      .build()
      .setRefreshToken(refreshToken);
}
    
}
