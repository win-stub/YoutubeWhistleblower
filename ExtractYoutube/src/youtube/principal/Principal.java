/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.principal;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.services.youtube.model.SearchResult;
import com.mongodb.DBCollection;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import youtube.auth.CredentialAuth;
import youtube.data.Search;
import youtube.date.GenerateDate;
import youtube.managedb.ManageDB;
import youtube.process.ProcessMetaData;
import youtube.txt.ManageTxt;
import youtube.youtube_dl.YoutubeDL;

/**
 *
 * @author user
 */
public class Principal {

    static ManageDB        managedb        = new ManageDB();
    static CredentialAuth  credential      = new CredentialAuth();
    static YoutubeDL       youtubedl       = new YoutubeDL();
    static ManageTxt       managetxt       = new ManageTxt();
    static ProcessMetaData processmetadata = new ProcessMetaData();
    static Search          search_youtube  = new Search();
    static GenerateDate    generate_date   = new GenerateDate();
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws IOException{
        // TODO code application logic here
        String select_application ="2";
        String directory_corpus   ="mondefr";        
        String file_to_youtube_sh ="";
        String file_id_video_out  ="";
        String file_to_keys_words ="Whistleblower";
        String year               ="2016"; 
        String month              ="8"; 
        String max_docs           ="50000000";        
        String serveur_name       ="localhost";
        int    port               =27017;
        int    port_server        =27017;
        String database_name      ="youtube";
        String collection_name    ="video.meta";
        String clientId           ="";
        String clientSecret       ="";
        String refreshToken       ="";
        
        if (args.length > 0) 
        {
              try 
              {   
                select_application = args[0];
                directory_corpus   = args[1];
                file_to_youtube_sh = args[2];                
                file_to_keys_words = args[3]; 
                year               = args[4]; 
                month              = args[5];
                max_docs           = args[6]; 
                file_id_video_out  = args[7]; 
                serveur_name       = args[8];
                port               = Integer.parseInt(args[9]);
                port_server        = Integer.parseInt(args[10]);
                database_name      = args[11];
                collection_name    = args[12];
                
                clientId           = args[13];
                clientSecret       = args[14];
                refreshToken       = args[15];
                //
                /*System.out.println("select_application  "+select_application);
                System.out.println("directory_corpus  "  +directory_corpus);
                //
                System.out.println("file_to_youtube_sh  "+file_to_youtube_sh);
                System.out.println("file_to_keys_words  "+file_to_keys_words);
                System.out.println("année de recherche  "+year);                
                System.out.println("max_docs            "+max_docs);
                System.out.println("file_id_video_out   "+file_id_video_out);
                System.out.println("serveur_name        "+serveur_name);
                System.out.println("port                "+port);
                System.out.println("port server         "+port_server);
                System.out.println("database_name       "+database_name);
                System.out.println("collection_name     "+collection_name);*/
              } 
              catch (Exception e) 
              {
                System.err.println("ERREUR ARGUMENT  "+e.getMessage());
                System.exit(1);
              }
        }    
        //System.out.println("Selection de l'application 0 generateur des metat_data youtube, 1 recuperateur du youtube");
        // Selection de l'application 0 generateur, 1 recuperateur du youtube
        if(select_application.equalsIgnoreCase("search_youtube-dl"))
        {
        youtubedl.searchVideo( file_to_youtube_sh   ,  
                               file_to_keys_words   , 
                               year                 ,
                               max_docs             ,
                               file_id_video_out
                            );        
        // Récupération de credential
        //Credential auth_crdential = credential.getCredential(port_server); 
        Credential auth_crdential = credential.getCredential(port_server,clientId, clientSecret, refreshToken);
            System.out.println("youtube.principal.Principal.main() ---> "+auth_crdential);
        //        
        if(auth_crdential!=null)
        {
            DBCollection collection = managedb.getCollection(collection_name, serveur_name, port, database_name);
            ArrayList array_video_id = managetxt.getVideosIds(file_id_video_out, "file_log");
            for (Object video_id : array_video_id) 
            {
                if(managedb.isExist(video_id.toString(), collection)==false){
                    processmetadata.lancer_youtube(auth_crdential, video_id.toString(), collection);
                }
                
            }
        }
        else
        {
            System.out.println("Erreur de credential");
        }        
        }
        
        // Generateurs des Méta-Données Pour youtube
        if(select_application.equalsIgnoreCase("generate"))
        {
            System.out.println("Generateurs des Méta-Données Pour youtube pour MongoDB");
            DBCollection collection = managedb.getCollection(collection_name, serveur_name, port, database_name);
            try
            {                           
                processmetadata.lancerGenerateurMongoDB(directory_corpus, collection, max_docs);           
            }
            catch(Exception e)
            {
                System.out.println("Exception "+e.getMessage());
            }
           
        }
        // Generateurs des Méta-Données Pour youtube
        if(select_application.equalsIgnoreCase("search_year"))
        {
        System.out.println("Récupération des IDs ");
        // Récupération de credential
        //Credential auth_crdential = credential.getCredential(port_server); 
        Credential auth_crdential = credential.getCredential(port_server,clientId, clientSecret, refreshToken);            
        //        
        if(auth_crdential!=null)
        {
            ArrayList array_date = generate_date.getAllDate(Integer.parseInt(year));
            /**
            * 
            */
            DBCollection collection = managedb.getCollection(collection_name, serveur_name, port, database_name); 
            /**
             * 
             */
                    for(int i=0;i<array_date.size();i++)
                    {
                        if (i+1<array_date.size())
                        {                        
                        /**
                         * 
                         */
                                List<SearchResult> video_id_result = search_youtube.searchVideo("resources/youtube.properties", 
                                                                                                file_to_keys_words            ,
                                                                                                array_date.get(i+1).toString()  ,
                                                                                                array_date.get(i).toString());                                
                                System.out.println(array_date.get(i).toString()+" --> "+array_date.get(i+1).toString()+" "+video_id_result.size());                                                                
                                if (video_id_result.size()>0)
                                {     
                                    /**
                                     * 
                                     */
                                    video_id_result.stream().forEach((video_id_result1) -> 
                                    {                       
                                            String video_id = video_id_result1.getId().getVideoId();
                                            
                                            if(managedb.isExist(video_id, collection)==false)
                                            {
                                                processmetadata.lancer_youtube(auth_crdential, video_id, collection);
                                            }

                                    });         
                                }                       
                        /**
                         * 
                         */
                        }                                     
                    }            
        }
        else
        {
            System.out.println("Erreur de credential");
        }                       
        }
        
        // Generateurs des Méta-Données Pour youtube
        if(select_application.equalsIgnoreCase("search_month_year"))
        {
        System.out.println("Récupération des IDs ");
        // Récupération de credential
        //Credential auth_crdential = credential.getCredential(port_server); 
        Credential auth_crdential = credential.getCredential(port_server,clientId, clientSecret, refreshToken);            
        //        
        if(auth_crdential!=null)
        {
            ArrayList array_date = generate_date.getAllDate(Integer.parseInt(year),Integer.parseInt(month));
            /**
            * 
            */
            DBCollection collection = managedb.getCollection(collection_name, serveur_name, port, database_name); 
            /**
             * 
             */
                    for(int i=0;i<array_date.size();i++)
                    {
                        if (i+1<array_date.size())
                        {                        
                        /**
                         * 
                         */
                                List<SearchResult> video_id_result = search_youtube.searchVideo("resources/youtube.properties", 
                                                                                                file_to_keys_words            ,
                                                                                                array_date.get(i+1).toString()  ,
                                                                                                array_date.get(i).toString());                                
                                System.out.println(array_date.get(i).toString()+" --> "+array_date.get(i+1).toString()+" "+video_id_result.size());                                                                
                                if (video_id_result.size()>0)
                                {     
                                    /**
                                     * 
                                     */
                                    video_id_result.stream().forEach((video_id_result1) -> 
                                    {                       
                                            String video_id = video_id_result1.getId().getVideoId();
                                            
                                            if(managedb.isExist(video_id, collection)==false)
                                            {
                                                processmetadata.lancer_youtube(auth_crdential, video_id, collection);
                                            }

                                    });         
                                }                       
                        /**
                         * 
                         */
                        }                                     
                    }            
        }
        else
        {
            System.out.println("Erreur de credential");
        }                       
        }        
    }
    
}
