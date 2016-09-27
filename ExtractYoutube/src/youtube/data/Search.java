package youtube.data;

import com.google.api.client.googleapis.json.GoogleJsonResponseException;
import com.google.api.client.http.HttpRequest;
import com.google.api.client.http.HttpRequestInitializer;
import com.google.api.client.util.DateTime;

import com.google.api.services.youtube.YouTube;
import com.google.api.services.youtube.model.SearchListResponse;
import com.google.api.services.youtube.model.SearchResult;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import youtube.auth.Auth;
import youtube.file.ReadProperties;
import youtube.print.Print;

/**
 * Affichage des videos correspoands aux criteres de recherche.
 *
 * @author Saber NOUIOUA
 */
public class Search {

    /**
     * Classe pour lire le fichier properties + API KEY
     */
    ReadProperties readProperties = new ReadProperties();
    Print print = new Print();
    /**
     * Définir une instance globale d'un objet Youtube , qui sera utilisé
     * Pour faire des demandes de l'API YouTube données     
     */
    private static YouTube youtube;
    
    public List<SearchResult> searchVideo(
                                          String propertiesFilaname  ,
                                          String queryTerm           , 
                                          String date_debut          ,
                                          String date_fin                                                      
                                         )
    {
        /**
         * Recuperation de la cle de developpement API KEY
         */
        Properties properties = readProperties.getProperties(propertiesFilaname);
        /**
         * Cet objet est utilisé pour faire des demandes de l'API YouTube données.
         * Le dernier argument est requis, mais puisque nous ne devons rien initialisée 
         * lorsque la requête HTTP est initialisée, 
         * nous remplacons l'interface et de fournir une fonction non-op
         */
        try {
            youtube = new YouTube.Builder
            (
                Auth.http_transport, 
                Auth.json_factory, 
                new HttpRequestInitializer() 
                {
                public void initialize(HttpRequest request) throws IOException 
                {}
                }
            ).setApplicationName("youtube_search").build();

            /**
             * Définir la demande d'API pour récupérer les résultats de recherche
             */
            
            YouTube.Search.List search = youtube.search().list("id,snippet");
            
            /**
             * Assigner la clé API KEY
             */
            String apiKey = properties.getProperty("youtube.apikey");
            search.setKey(apiKey);
            search.setQ(queryTerm);
            search.setPublishedBefore(new DateTime(date_debut));
            search.setPublishedAfter(new DateTime(date_fin));

            /**
             * Restreindre les résultats de la recherche pour inclure uniquement les vidéos
             * voir https://developers.google.com/youtube/v3/docs/search/list#type
             */            
            search.setType("video");                        
            /**
             * Définition des champs de recupération
             */
            search.setFields("items(id/kind,id/videoId,snippet/title,snippet/thumbnails/default/url)");
            search.setMaxResults(new Long(50));
            
            SearchListResponse searchResponse = search.execute();
            List<SearchResult> searchResultList = searchResponse.getItems();
            //
            //print.getInfoYoutube(searchResultList.listIterator(), "france",youtube);
            //
            return searchResultList;
            
        } catch (GoogleJsonResponseException e) 
        {
            System.err.println("There was a service error: " + e.getDetails().getCode() + " : "+ e.getDetails().getMessage());
        } catch (IOException e) 
        {
            System.err.println("There was an IO error: " + e.getCause() + " : " + e.getMessage());
        } catch (Throwable t) 
        {
            t.printStackTrace();
        }       
        return new ArrayList<SearchResult>();
    }       
    
}
