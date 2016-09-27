package youtube.transcription;

/*
    This file is part of Google2SRT.

    Google2SRT is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Google2SRT is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Google2SRT.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 *
 * @author kom
 * @author Zoltan Kakuszi
 * @version "0.7.4, 10/19/15"
 */

import java.io.FileNotFoundException;
import java.net.MalformedURLException;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.List;


public class Controller {

    private List<Video> videos;                             // List of videos
    private Settings appSettings;                           // Application settings                                          // GUI
    private List<List<NetSubtitle>> lSubsWithTranslations;  // Tracks (item 0) + Targets (item 1)
    
    protected void addTracks(List<NetSubtitle> subtitles) {
        lSubsWithTranslations.get(0).addAll(subtitles);
    }
    
    protected void addTargets(List<NetSubtitle> subtitles) {
        lSubsWithTranslations.get(1).addAll(subtitles);
    }
    
    protected List<NetSubtitle> getTracks() {
        return lSubsWithTranslations.get(0);
    }
    
    protected List<NetSubtitle> getTargets() {
        return lSubsWithTranslations.get(1);
    }
    
    public Controller(Settings settings) {
        this.appSettings = settings;                                
    }    
    // Data structure initialisation
    protected final void initSubtitlesDataStructure() {
        lSubsWithTranslations = new ArrayList<List<NetSubtitle>>();
        lSubsWithTranslations.add(new ArrayList<NetSubtitle>());
        lSubsWithTranslations.add(new ArrayList<NetSubtitle>());
    }    
    
    // Returns subtitles for one video URL
    protected List<Video> processInputURL(String url) {
        videos = new ArrayList<Video>();
        videos.add(new Video(url));
        retrieveSubtitles();
        return videos;
    }
    
    // Returns true if there is not at least 1 track and 1 target
    protected boolean islSubsWithTranslationsNull() {
        List<List<NetSubtitle>> swt = lSubsWithTranslations;
        return (swt == null || swt.size() < 2 ||
                swt.get(0) == null ||  swt.get(0).isEmpty() ||
                swt.get(1) == null ||  swt.get(1).isEmpty());
    }


    // Retrieves LIST of subtitles from the network
    public void retrieveSubtitles() {
        List<List<NetSubtitle>> al;
        List<NetSubtitle> al1;
        List<Video> invalidVideos;
        
        invalidVideos = new ArrayList<Video>();                        
       // Check if URL is valid
        for (Video v : this.videos) {
            try {                     
                al1 = v.getSubtitles();                
            } catch (Video.HostNoGV e) {
                System.out.println(""+e.getMessage());                
                invalidVideos.add(v);
                continue;
            } catch (Video.NoDocId e) {
                System.out.println(""+e.getMessage());               
                invalidVideos.add(v);
                continue;
            } catch (Video.NoQuery e) {
                System.out.println(""+e.getMessage());               
                invalidVideos.add(v);
                continue;
            } catch (Video.InvalidDocId e) {
                System.out.println(""+e.getMessage());              
                invalidVideos.add(v);
                continue;
            } catch (Video.NoSubs e) {
                System.out.println(""+e.getMessage());                
                invalidVideos.add(v);
                continue;
            } catch (MalformedURLException e) {
                System.out.println(""+e.getMessage());                
                invalidVideos.add(v);
                continue;
            } catch (org.jdom.input.JDOMParseException e) {
                System.out.println(""+e.getMessage());                
                invalidVideos.add(v);
                continue;
            } catch (java.net.UnknownHostException e) {
                System.out.println(""+e.getMessage());               
                invalidVideos.add(v);
                continue;
            } catch (FileNotFoundException e) {
                System.out.println(""+e.getMessage());                
                invalidVideos.add(v);
                continue;
            } catch (Video.NoYouTubeParamV e) {
                System.out.println(""+e.getMessage());                
                invalidVideos.add(v);
                continue;
            } catch (SocketException e) {
                System.out.println(""+e.getMessage());                
                invalidVideos.add(v);
                continue;
            } catch (Exception e) {
                System.out.println(""+e.getMessage());                
                invalidVideos.add(v);
                continue;
            }
        }        
        // Removing invalid "videos" (text lines not containing a URL or a video without subtitles)
        for (Video v : invalidVideos)
            this.videos.remove(v);        
                
    } 
}