/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.data;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.api.services.youtube.YouTube;
import com.google.api.services.youtube.model.Video;
import com.google.api.services.youtube.model.VideoListResponse;
import com.mongodb.BasicDBObject;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import youtube.auth.Auth;
import youtube.file.ReadProperties;

/**
 *
 * @author Saber NOUIOUA
 */
public class InfoVideo {

    ReadProperties readProperties = new ReadProperties();    
    private static YouTube youtube;
    
    public BasicDBObject getInfoVideo(Credential credential, String videoId, String listFields){        
        /**
         * Cet objet est utilisé pour faire des demandes de l'API YouTube données.
         * Le dernier argument est requis, mais puisque nous ne devons rien initialisée 
         * lorsque la requête HTTP est initialisée, 
         * nous remplacons l'interface et de fournir une fonction non-op
         */
        try {
            // Assignation de credential au API Youtube
            youtube = new YouTube.Builder(Auth.http_transport, Auth.json_factory, credential)
                    .setApplicationName("youtube-info").build();          
            /**
             * Définir la demande d'API pour récupérer les résultats de recherche
             */
            YouTube.Videos.List listVideosRequest = youtube.videos().list(listFields).setId(videoId);
            
            VideoListResponse listResponse = listVideosRequest.execute();  
            /**
             * Création d'un objet BasicDBObject pour la base de données MongoDB
             */
            BasicDBObject basic_dbobject = new BasicDBObject();
            /**
             * 
             */
            List<Video> videoList = listResponse.getItems();    
                    if (videoList != null) 
                    {
                    Video singleVideo = videoList.get(0);
                    /**
                     * Information globale
                     */                    
                    basic_dbobject.put("_id", singleVideo.getId());
                    basic_dbobject.put("title", singleVideo.getSnippet().getTitle());
                    basic_dbobject.put("channelid", singleVideo.getSnippet().getChannelId());
                    basic_dbobject.put("channeltitle", singleVideo.getSnippet().getChannelTitle());
                    if(singleVideo.getSnippet().getPublishedAt()!=null){
                    basic_dbobject.put("datepub",new Date(singleVideo.getSnippet().getPublishedAt().getValue()));
                    }                                                             
                    basic_dbobject.put("description", singleVideo.getSnippet().getDescription());                    
                    basic_dbobject.put("tags", singleVideo.getSnippet().getTags());
                    /**
                     * Langage de la video
                     */
                    basic_dbobject.put("kind", singleVideo.getKind());
                    basic_dbobject.put("defaultaudiolang", singleVideo.getSnippet().getDefaultAudioLanguage());
                    basic_dbobject.put("defaultlang", singleVideo.getSnippet().getDefaultLanguage());
                    /**
                     * Statistique
                     */                                    
                    basic_dbobject.put("viewcount", singleVideo.getStatistics().getViewCount().toString());
                    basic_dbobject.put("likecount", singleVideo.getStatistics().getLikeCount().toString());
                    basic_dbobject.put("dislikecount", singleVideo.getStatistics().getDislikeCount().toString());
                    basic_dbobject.put("commentscount", singleVideo.getStatistics().getCommentCount().toString());
                    /**
                     * Localisation
                     */
                    if(singleVideo.getRecordingDetails()!=null)
                    {
                    basic_dbobject.put("latitude", singleVideo.getRecordingDetails().getLocation().getLatitude());
                    basic_dbobject.put("longitude", singleVideo.getRecordingDetails().getLocation().getLongitude());
                    basic_dbobject.put("locationdesc", singleVideo.getRecordingDetails().getLocationDescription()); 
                    }
                    
                    }         
            return basic_dbobject;
        } 
        catch (GoogleJsonResponseException e) 
        {
            System.err.println("There was a service error: " + e.getMessage());
                        
            System.err.println("There was a service error: " + e.getDetails().getCode() + " : "
                    + e.getDetails().getMessage());
        } 
        catch (IOException e) 
        {
            System.err.println("There was an IO error: " + e.getCause() + " : " + e.getMessage());
            e.printStackTrace();
        } 
        catch (Throwable t) 
        {
            System.err.println(t.getMessage());
            t.printStackTrace();
        }
        return null;
    }
}
