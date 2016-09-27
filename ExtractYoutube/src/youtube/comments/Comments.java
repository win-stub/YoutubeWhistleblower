package youtube.comments;

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.api.services.youtube.YouTube;
import com.google.api.services.youtube.model.CommentSnippet;
import com.google.api.services.youtube.model.CommentThread;
import com.google.api.services.youtube.model.CommentThreadListResponse;
import com.mongodb.BasicDBObject;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import youtube.auth.Auth;



/**
 *
 * @author user
 */
public class Comments {
   
    private static YouTube youtube;
    
    public ArrayList getComments(Credential credential, String videoId)
    {    
        ArrayList array_comments = new ArrayList();
        try {           
            /**
             * Assignation de credential au API Youtube
             */            
            youtube = new YouTube.Builder(Auth.http_transport, Auth.json_factory, credential)
                    .setApplicationName("youtube-comments").build();                                
            /**
             * Appel à la fonction commentThreads
             */                              
            CommentThreadListResponse videoCommentsListResponse = youtube.commentThreads()
                    .list("snippet").setVideoId(videoId).setTextFormat("plainText").setMaxResults(new Long(100)).execute();
            
            List<CommentThread> videoComments = videoCommentsListResponse.getItems();            
            if (videoComments.isEmpty()) 
            {
                System.out.println("Impossible de recuperer les commentaires");
                return array_comments;
            } 
            else 
            {                               
                for(int i=0;i<videoComments.size();i++)
                {
                    BasicDBObject basic_dbobject = new BasicDBObject();
                    CommentThread videoComment = videoComments.get(i);
                    /**
                    * Création d'un objet BasicDBObject pour la base de données MongoDB
                    */                    
                    CommentSnippet snippet = videoComment.getSnippet().getTopLevelComment().getSnippet();
                    basic_dbobject.put("author"  , snippet.getAuthorDisplayName());
                    basic_dbobject.put("like"    , snippet.getLikeCount());                
                    basic_dbobject.put("message" , snippet.getTextDisplay());  
                    /**
                     * Ajouter basicdbobject dans array_comments
                     */                    
                    array_comments.add(basic_dbobject);
                }
                /*videoComments.stream().forEach((<any> videoComment) -> {*/
                 /**
                 * Création d'un objet BasicDBObject pour la base de données MongoDB
                 */
                /*BasicDBObject basic_dbobject = new BasicDBObject();
                CommentSnippet snippet = videoComment.getSnippet().getTopLevelComment().getSnippet();
                basic_dbobject.put("author"  , snippet.getAuthorDisplayName());
                basic_dbobject.put("like"    , snippet.getLikeCount());                
                basic_dbobject.put("message" , snippet.getTextDisplay()); */
                /**
                 * Ajouter basicdbobject dans array_comments
                 */
                /*array_comments.add(basic_dbobject);
                });*/
            }
            return array_comments;
        } 
        catch (GoogleJsonResponseException e) 
        {
            System.err.println("GoogleJsonResponseException code: " + e.getMessage());
            
            //System.err.println("GoogleJsonResponseException code: " + e.getDetails().getCode()
            //        + " : " + e.getDetails().getMessage());
            //e.printStackTrace();

        } 
        catch (IOException e) 
        {
            System.err.println("IOException: " + e.getMessage());
            //e.printStackTrace();
        } 
        catch (Throwable t) 
        {
            System.err.println("Throwable: " + t.getMessage());
            //t.printStackTrace();
        }
        return null;
    }
}
