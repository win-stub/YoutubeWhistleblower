/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package youtube.print;

import com.google.api.services.youtube.YouTube;
import com.google.api.services.youtube.model.ResourceId;
import com.google.api.services.youtube.model.SearchResult;
import com.google.api.services.youtube.model.Thumbnail;
import java.util.Iterator;
import youtube.comments.Comments;

/**
 *
 * @author user
 */
public class Print {

Comments comments = new Comments();
public void getInfoYoutube(Iterator<SearchResult> iteratorSearchResults, String query,YouTube youtube) {

    System.out.println("=============================================================\n");

    if (!iteratorSearchResults.hasNext()) {
        System.out.println(" pas de resulats touves ");
    }

    while (iteratorSearchResults.hasNext()) {

    
    SearchResult singleVideo = iteratorSearchResults.next();
    
    ResourceId rId = singleVideo.getId();        

    if (rId.getKind().equals("youtube#video")) {
        Thumbnail thumbnail = singleVideo.getSnippet().getThumbnails().getDefault();

        System.out.println(" Video Id               " + rId.getVideoId());
        //
        comments.getComments(null,rId.getVideoId());
        //
        /*System.out.println(" Channel id             " + singleVideo.getSnippet().getChannelId());
        System.out.println(" Channel Title          " + singleVideo.getSnippet().getChannelTitle());
        //System.out.println(" Playlist id            " + singleVideo.);
        
        
        System.out.println(" Title                  " + singleVideo.getSnippet().getTitle());
        System.out.println(" Date de publication    " + singleVideo.getSnippet().getPublishedAt());
        System.out.println(" Description            " + singleVideo.getSnippet().getDescription());
        System.out.println(" Thumbnail              " + thumbnail.getUrl());
        System.out.println(" Date de publication    " + singleVideo.getSnippet().getPublishedAt());
        
        
        
        System.out.println("\n-------------------------------------------------------------\n");*/
    }
    }
}
}
