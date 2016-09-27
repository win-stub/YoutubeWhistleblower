/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.process;

import com.google.api.client.auth.oauth2.Credential;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import generatortxt.Generateur;
import java.util.ArrayList;
import java.util.Date;
import youtube.comments.Comments;
import youtube.data.InfoVideo;
import youtube.managedb.ManageDB;
import youtube.transcription.Transcription;
import youtube.txt.ManageTxt;

/**
 *
 * @author user
 */
public class ProcessMetaData {

    ManageTxt       manage_txt    = new ManageTxt();
    ManageDB        mnagedb       = new ManageDB();
    Comments        comments      = new Comments();
    InfoVideo       infovideo     = new InfoVideo();
    Generateur      generateur    = new Generateur();
    Transcription   transcription = new Transcription();
    public void lancer_youtube(
                               Credential auth_crdential , 
                               String video_id           ,
                               DBCollection collection
                              )
    {
        try
        {
            System.out.println("youtube.process.ProcessMetaData.lancer_youtube() ");
            // Récupération des information concernant le video
            BasicDBObject basic_dbobject = infovideo.getInfoVideo (auth_crdential   , 
                                                                   video_id         , 
                                                                   "snippet," +
                                                                   "contentDetails," +                                                                                                                                                        
                                                                   "recordingDetails," +                                                                            
                                                                   "statistics,localizations"
                                                                   );
            // Récupération des commentaires concernant le video
            ArrayList arra_comments = comments.getComments(auth_crdential, video_id);
            // Ajouter comments à la collection
            basic_dbobject.put("comments", arra_comments);
            // Ajouter la transcription exemple de url : https://www.youtube.com/watch?v=g8bt8eUB1CU
            //System.out.println("youtube.process.ProcessMetaData.lancer_youtube() "+"https://www.youtube.com/watch?v="+video_id);
            String transcription_txt = transcription.getTRANSCRIPTION("https://www.youtube.com/watch?v="+video_id);
            basic_dbobject.put("transcription", transcription_txt);
            // Ajouter le champs is_ling =false : on a pas encore calculer la partie linguistique
            basic_dbobject.put("is_ling", "false");
            // Sauvegarde dans la base de données
            mnagedb.addMetaData(collection,basic_dbobject);            
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }
        
    }
/**
 * Générateur Automatique
 * @param directory_corpus_name
 * @param max_docs
 * @param collection 
 */    
    public void lancerGenerateurMongoDB(String directory_corpus_name ,
                                        DBCollection collection      ,
                                        String max_docs
                                       )
    {
        try
        {
            // Set directory of corpus
            generateur.setDirectoryCorpus(directory_corpus_name);
            for(int i=0;i<Integer.parseInt(max_docs);i++)
            {            
            System.out.println("video_id generated : "+i);
            // Récupération des information concernant le video
            BasicDBObject basic_dbobject = new BasicDBObject();
                    basic_dbobject.put("_id", ""+i);
                    basic_dbobject.put("title", generateur.getTitle(7, 20, 10));                    
                    basic_dbobject.put("channelid", generateur.getChannelId());
                    basic_dbobject.put("channeltitle", generateur.getTitle(7, 20, 10));                    
                    basic_dbobject.put("datepub",new Date(generateur.getDatePub(28, 12, 2016)));                       
                    basic_dbobject.put("description", generateur.getDescription(7, 50, 10));                    
                    basic_dbobject.put("tags", generateur.getTags(7, 10, 5, 10));
                    /**
                     * Langage de la video
                     */
                    basic_dbobject.put("kind", generateur.getTitle(7, 10, 5));
                    basic_dbobject.put("defaultaudiolang", "");
                    basic_dbobject.put("defaultlang", "");
                    /**
                     * Statistique
                     */                                    
                    basic_dbobject.put("viewcount", generateur.getChannelId());
                    basic_dbobject.put("likecount", generateur.getChannelId());
                    basic_dbobject.put("dislikecount", generateur.getChannelId());
                    basic_dbobject.put("commentscount", generateur.getChannelId());
                    /**
                     * Localisation
                     */                   
                    basic_dbobject.put("latitude", generateur.getChannelId());
                    basic_dbobject.put("longitude", generateur.getChannelId());
                    basic_dbobject.put("locationdesc", generateur.getChannelId());
                               
            // Récupération des commentaires concernant le video
            Object[] arra_comments_author = generateur.getComments(7, 20,10,10,5, 20);
            ArrayList array_comments_generater = (ArrayList)arra_comments_author[0];
            ArrayList array_authors_generater  = (ArrayList)arra_comments_author[1];
            ArrayList array_comments           = new ArrayList();
            // Ajouter comments à la collection            
            if(array_comments_generater.size()!=0)
            {                                      
            for(int j=0;j<array_comments_generater.size();j++)
            {
                BasicDBObject basic_dbobject_comments = new BasicDBObject();
                basic_dbobject_comments.put("author", array_authors_generater.get(j).toString());
                basic_dbobject_comments.put("like", generateur.getChannelId());
                basic_dbobject_comments.put("message", array_comments_generater.get(j).toString());
                //
                array_comments.add(basic_dbobject_comments);
            }            
            }
            else
            {
                BasicDBObject basic_dbobject_comments = new BasicDBObject();
                array_comments.add(basic_dbobject_comments);
            }

            basic_dbobject.put("comments", array_comments);
            // Sauvegarde dans la base de données
            mnagedb.addMetaData(collection,basic_dbobject);
            //
            }
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        
    }
   
}
